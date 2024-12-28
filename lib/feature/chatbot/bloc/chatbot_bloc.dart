import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  ChatbotBloc() : super(ChatbotInitialState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<PickImageEvent>(_onPickImage);
    on<StartSpeechToTextEvent>(_onStartSpeechToText);
  }

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final ImagePicker _picker = ImagePicker();

  // Handle sending a message event
  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoadingState());
    try {
      final response = await _getOpenAIResponse(event.message);
      emit(ChatbotMessageState(response: response));
    } catch (e) {
      emit(ChatbotErrorState(error: e.toString()));
    }
  }

  // Handle picking an image event
  Future<void> _onPickImage(
      PickImageEvent event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoadingState());
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File image = File(pickedFile.path);
        final result = await _performImageRecognition(image);
        emit(ChatbotImageRecognitionState(result: result));
      } else {
        emit(ChatbotErrorState(error: "No image selected"));
      }
    } catch (e) {
      emit(ChatbotErrorState(error: e.toString()));
    }
  }

  // Handle starting speech-to-text event
  Future<void> _onStartSpeechToText(
      StartSpeechToTextEvent event, Emitter<ChatbotState> emit) async {
    emit(ChatbotLoadingState());
    try {
      bool available = await _speechToText.initialize();
      if (available) {
        _speechToText.listen(onResult: (result) {
          add(SendMessageEvent(message: result.recognizedWords));
        });
      } else {
        emit(ChatbotErrorState(error: "Speech-to-text not available"));
      }
    } catch (e) {
      emit(ChatbotErrorState(error: e.toString()));
    }
  }

  // Function to call OpenAI API
  Future<String> _getOpenAIResponse(String message) async {
    const String apiKey = 'YOUR_OPENAI_API_KEY'; // Replace with your OpenAI key
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'model': 'gpt-4', // Use the latest model if available, like GPT-4
      'messages': [
        {'role': 'user', 'content': message}
      ],
      'max_tokens': 150,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load response from OpenAI');
    }
  }

  // Perform image recognition (Placeholder function)
  Future<String> _performImageRecognition(File image) async {
    // You can integrate TFLite or Firebase ML for image recognition here.
    // Example for Firebase ML (ensure Firebase is initialized):

    try {
      // Placeholder for actual image recognition
      return "Recognized Object: Example"; // Return placeholder result
    } catch (e) {
      throw Exception('Failed to recognize image: $e');
    }
  }
}
