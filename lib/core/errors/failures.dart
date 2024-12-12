import 'package:equatable/equatable.dart';

/// Core Failure abstract class
///
/// To be used in combination with the Dartz package, to implement the
/// functional programming Either paradigm. Must be extended into a core
/// collection of expected failure categories.
abstract class Failure extends Equatable {
  final List properties = const <dynamic>[];

  Failure([properties]);

  @override
  List<Object> get props => [properties];
}

/// Remote server failure
///
/// Returned when there is an error interacting with a remote resource of
/// some kind.
///
/// This should be extended further by individual components to specify more
/// explicit failure types, but still allow us to confirm the core failure
/// type.
class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

/// Local cache failure
///
/// Returned when there is an error interacting with locally stored data.
///
/// This should be extended further by individual components to specify more
/// explicit failure types, but still allow us to confirm the core failure
/// type.
class CacheFailure extends Failure {
  final String message;
  CacheFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

class ApiFailure extends Failure {
  final String message;
  ApiFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

class UserNotConfirmedFailure extends Failure {
  final String message;
  UserNotConfirmedFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

/// System failure
///
/// Returned when there is an error interacting with the local system, but the
/// error is not related to the handling of physical data.
///
/// This should be extended further by individual components to specify more
/// explicit failure types, but still allow us to confirm the core failure
/// type.
class InternalFailure extends Failure {
  final String message;
  InternalFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

/// Timeout failure
///
/// Returned when there is an error interacting with remote api, when
/// server is not able to respond and timeout occurs
///
class TimeoutFailure extends ServerFailure {
  TimeoutFailure(String message) : super(message);

  @override
  String toString() {
    return message;
  }
}

/// ServiceUnavailable failure
///
/// Thrown when the API is temporarily unavailable
/// This may occur in a couple of scenarios - when the API is under planned
/// maintenance, or there is an unplanned outage.
class ServiceUnavailableFailure extends ServerFailure {
  ServiceUnavailableFailure(String message) : super(message);

  @override
  String toString() {
    return message;
  }
}

///PermissionDenied failure
///
/// Thrown when the user is not authenticated / authorised to take an action
/// This may be returned if the user's credentials are bad, or they have tried
/// to access a resource which their account is disallowed from accessing.
class PermissionDeniedFailure extends ServerFailure {
  PermissionDeniedFailure(String message) : super(message);

  @override
  String toString() {
    return message;
  }
}

///AdLoadFailure failure
///
/// Thrown when any of ad fails to load
class AdLoadFailure extends Failure {
  final String message;
  AdLoadFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

///Unknow failure
///
/// Thrown when any of request fails due to unknown reason
class UnknownFailure extends Failure {
  final String message;
  UnknownFailure(this.message);

  @override
  String toString() {
    return message;
  }
}
