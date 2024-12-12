import 'package:chadbot/feature/chat/domain/entity/message.dart';

abstract class KProfileState {
  KProfileState();
}

class KProfileSaveInitial extends KProfileState {
  KProfileSaveInitial() : super();

  @override
  String toString() => "KProfileSaveInitial";
}

class KProfileSaveInProgress extends KProfileState {
  final List<Message> messageList;
  KProfileSaveInProgress(this.messageList) : super();

  @override
  String toString() => "KProfileSaveInProgress";
}

class KProfileSaveSuccess extends KProfileState {
  KProfileSaveSuccess() : super();

  @override
  String toString() => "ProfileSaveSuccess";
}

class KProfileSaveFailure extends KProfileState {
  final String errorMessage;
  KProfileSaveFailure(this.errorMessage) : super();
  @override
  String toString() => "KProfileSaveFailure";
}
