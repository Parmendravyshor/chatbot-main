import 'dart:async';
import 'dart:convert';

import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/database.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/feature/chat/domain/entity/message.dart';
import 'package:chadbot/feature/chat/domain/usecases/get_text_file.dart';
import 'package:chadbot/feature/chat/presentation/bloc/chat_event.dart';
import 'package:chadbot/feature/chat/presentation/bloc/chat_state.dart';
import 'package:chadbot/feature/login/domain/usecases/email_signin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:sqflite/sqflite.dart';

/// Bloc for CHhat page
///
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SharedPrefHelper sharedPrefHelper;
  final EmailSignin emailSignin;
  final GetTextFile getTextFile;

  List<Message> messageList = [];
  late Database _database;
  int tried = 0; // To track retries
  bool isFromException = false;

  ChatBloc(
    this.sharedPrefHelper,
    this.emailSignin,
    this.getTextFile,
  ) : super(ChatSendInitial()) {
    // Handle ChatOpened Event
    on<ChatOpened>(_onChatOpened);

    // Handle ChatMessageSent Event
    on<ChatMessageSent>(_onChatMessageSent);
  }

  /// Event Handler: Load Existing Chat Messages
  Future<void> _onChatOpened(ChatOpened event, Emitter<ChatState> emit) async {
    try {
      _database = await DBProvider.db.database;

      final List<Map<String, dynamic>> maps = await _database.query('message');
      messageList = List.generate(maps.length, (i) {
        return Message(
          maps[i]['message'],
          maps[i]['type'],
        );
      });

      emit(ChatSendSuccess(messageList));
    } catch (e) {
      emit(ChatSendFailure("Failed to load chat messages"));
    }
  }

  /// Event Handler: Process Sent Messages and Server Response
  Future<void> _onChatMessageSent(
      ChatMessageSent event, Emitter<ChatState> emit) async {
    tried++;

    // Avoid sending duplicate retries caused by exceptions
    if (isFromException) {
      isFromException = false;
    } else {
      final sentMessage = Message(event.message, 1);
      messageList.add(sentMessage);
      emit(ChatSendInProgress(messageList));

      await _database.insert("message", sentMessage.toMap());
    }

    // Check for token expiration and refresh if needed
    final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(sharedPrefHelper.getExpiryTime()) * 1000);
    if (expiryTime.isBefore(DateTime.now())) {
      await emailSignin(EmailAuthParams(
        email: sharedPrefHelper.getEmail(),
        password: sharedPrefHelper.getPassword(),
        fName: "",
        lName: "",
      ));
    }

    // Attempt to get data from the server
    try {
      final response =
          await getData(event.message, sharedPrefHelper.getIdJwtToken());

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var body = jsonDecode(jsonResponse['body']);
        var message = body['Answer'];

        final receivedMessage = Message(message, 2);
        messageList.add(receivedMessage);
        await _database.insert("message", receivedMessage.toMap());

        emit(ChatSendSuccess(messageList));
      } else {
        // Retry logic
        if (tried % 3 != 0) {
          isFromException = true;
          add(event);
        } else {
          emit(ChatSendFailure("Failed to get response after retries."));
        }
      }
    } on TimeoutException {
      emit(ChatSendFailure("Request timed out. Please try again."));
    } catch (e) {
      emit(ChatSendFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }
}

/// API Call to fetch data
Future<http.Response> getData(String question, String jwtToken) {
  return http
      .post(
    Uri.https(ChadbotConstants.modelendpoint, ChadbotConstants.corePath),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(
      <String, String>{"utterance": question, "jwttoken": jwtToken},
    ),
  )
      .timeout(Duration(seconds: 30), onTimeout: () {
    throw TimeoutException("timeout occurred");
  });
}
