import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/chatbot_bloc.dart';
import 'bloc/chatbot_event.dart';
import 'bloc/chatbot_state.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  String _imageResult = '';
  String _speechText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chatbot")),
      body: BlocProvider(
        create: (_) => ChatbotBloc(),
        child: BlocConsumer<ChatbotBloc, ChatbotState>(
          listener: (context, state) {
            if (state is ChatbotMessageState) {
              setState(() {
                _response = state.response;
              });
            } else if (state is ChatbotImageRecognitionState) {
              setState(() {
                _imageResult = state.result;
              });
            } else if (state is ChatbotSpeechToTextState) {
              setState(() {
                _speechText = state.speechText;
              });
            } else if (state is ChatbotErrorState) {
              setState(() {
                _response = state.error;
              });
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _controller,
                    decoration:
                        InputDecoration(labelText: "Ask me anything..."),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        context
                            .read<ChatbotBloc>()
                            .add(SendMessageEvent(message: _controller.text));
                      }
                    },
                    child: Text('Send'),
                  ),
                  SizedBox(height: 20),
                  if (state is ChatbotLoadingState)
                    Center(child: CircularProgressIndicator()),
                  if (_response.isNotEmpty) Text("Response: $_response"),
                  if (_imageResult.isNotEmpty)
                    Text("Image Recognition Result: $_imageResult"),
                  if (_speechText.isNotEmpty)
                    Text("Speech-to-Text: $_speechText"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatbotBloc>().add(PickImageEvent());
                    },
                    child: Text("Pick Image for Recognition"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatbotBloc>().add(StartSpeechToTextEvent());
                    },
                    child: Text("Start Speech-to-Text"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
