import 'package:chadbot/feature/chat/domain/entity/message.dart';

abstract class ChatState {
  ChatState();
}

class ChatSendInitial extends ChatState {
  ChatSendInitial() : super();

  @override
  String toString() => "ChatSendInitial";
}

class ChatSendInProgress extends ChatState {
  final List<Message> messageList;
  ChatSendInProgress(this.messageList) : super();

  @override
  String toString() => "ChatSendInProgress";
}

class ChatSendSuccess extends ChatState {
  final List<Message> messageList;
  ChatSendSuccess(this.messageList) : super();

  @override
  String toString() => "ChatSendSuccess";
}

class ChatSendFailure extends ChatState {
  final String errorMessage;
  ChatSendFailure(this.errorMessage) : super();
  @override
  String toString() => "ChatSendFailure";
}
