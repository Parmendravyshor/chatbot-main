/// Events class for Chat screen
abstract class ChatEvent {
  ChatEvent();
}

/// Chat Opened
///
/// This event is fired when Chat is opened
class ChatOpened extends ChatEvent {
  ChatOpened();

  @override
  String toString() => "ChatOpened";
}

/// Chat Opened
///
/// This event is fired when Chat is opened
class ChatMessageSent extends ChatEvent {
  final String message;
  ChatMessageSent(this.message);

  @override
  String toString() => "ChatMessageSent";
}
