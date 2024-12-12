import 'package:chadbot/core/errors/failures.dart';

/// When user is not found on Firebase, this is the error that is thrown
class UserNotFoundFailure extends Failure {
  @override
  String toString() {
    return "UserNotFoundFailure";
  }
}

/// In email-password based login, this error will be thrown when password
/// is incorrect
class BadCredentialsFailure extends Failure {
  @override
  String toString() {
    return "BadCredentialsFailure";
  }
}

/// In email-password based login, this error will be thrown when email
/// already exist
class EmailAlreadyInUseFailure extends Failure {
  @override
  String toString() {
    return "EmailAlreadyInUseFailure";
  }
}

/// Every other type of authentication failure will be covered by this.
class UnknownAuthenticationFailure extends Failure {
  final String message;
  UnknownAuthenticationFailure(this.message);

  @override
  String toString() {
    return "UnknownAuthenticationFailure:$message";
  }
}

///  Social signin cancelled by user will be cover by this failure type
class UserCancelledSigninFailure extends Failure {
  final String message;
  UserCancelledSigninFailure(this.message);

  @override
  String toString() {
    return "UserCancelledSigninFailure:$message";
  }
}
