abstract class AuthException implements Exception {}

/// This exception is thrown when unknow auth error occurs
///
class UnknownAuthException extends AuthException {
  final String message;
  UnknownAuthException(this.message);
  @override
  String toString() {
    return message;
  }
}
