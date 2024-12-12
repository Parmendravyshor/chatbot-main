class Message {
  final String message;
  final int messageType;
  Message(this.message, this.messageType);

  String get text => message;
  int get typeOfMsg => messageType;

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'type': messageType,
    };
  }

  @override
  String toString() {
    return 'Message{message: $message, type: $messageType}';
  }
}
