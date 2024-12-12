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
  List<Message> messageList = [];
  final SharedPrefHelper sharedPrefHelper;
  final EmailSignin emailSignin;
  final GetTextFile getTextFile;
  ChatBloc(
    this.sharedPrefHelper,
    this.emailSignin,
    this.getTextFile,
  ) : super(ChatSendInitial());

  late Database _database;
  int tried = 0;
  bool isFromException = false;

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatOpened) {
      _database = await DBProvider.db.database;

      final List<Map<String, dynamic>> maps = await _database.query('message');
      messageList = List.generate(maps.length, (i) {
        return Message(
          maps[i]['message'],
          maps[i]['type'],
        );
      });

      yield ChatSendSuccess(messageList);
    } else if (event is ChatMessageSent) {
      tried++;

      if (isFromException) {
        isFromException = false;
      } else {
        final sentMessage = Message(event.message, 1);
        messageList.add(sentMessage);
        yield ChatSendInProgress(messageList);
        await _database.insert("message", sentMessage.toMap());
      }

      DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(sharedPrefHelper.getExpiryTime()) * 1000);

      if (expiryTime.isBefore(DateTime.now())) {
        await emailSignin(EmailAuthParams(
            email: sharedPrefHelper.getEmail(),
            password: sharedPrefHelper.getPassword(),
            fName: "",
            lName: ""));
      }

      try {
        final response =
            await getData(event.message, sharedPrefHelper.getIdJwtToken());
        if (response.statusCode == 200) {
          try {
            var jsonResponse = convert.jsonDecode(response.body);
            var body = convert.jsonDecode(jsonResponse['body']);
            var message = body['Answer'];
            final receivedMessage = Message(message, 2);
            messageList.add(receivedMessage);
            await _database.insert("message", receivedMessage.toMap());

            yield ChatSendSuccess(messageList);
          } catch (e) {}
        } else {
          if (tried % 3 != 0) {
            isFromException = true;
            add(event);
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}

Future<http.Response> getData(String question, String jwtToken) {
  return http
      .post(
    Uri.https(ChadbotConstants.modelendpoint, ChadbotConstants.corePath),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(
        <String, String>{"utterance": question, "jwttoken": jwtToken}),
  )
      .timeout(Duration(seconds: 30), onTimeout: () {
    throw TimeoutException("timeout occurred");
  });
}
