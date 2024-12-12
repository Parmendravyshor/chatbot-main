abstract class ResetState {
  ResetState();
}

class ResetInitial extends ResetState {
  ResetInitial() : super();

  @override
  String toString() => "ResetInitial";
}

class ResetInProgress extends ResetState {
  ResetInProgress() : super();

  @override
  String toString() => "ResetInProgress";
}

class ResetSuccess extends ResetState {
  ResetSuccess() : super();

  @override
  String toString() => "ResetSuccess";
}

class ResetFailure extends ResetState {
  final String errorMessage;
  ResetFailure(this.errorMessage) : super();
  @override
  String toString() => "ResetFailure";
}

class ResetFormValidationSuccess extends ResetState {
  ResetFormValidationSuccess() : super();

  @override
  String toString() => "ResetFormValidationSuccess";
}

class ResetPasswordMessageSent extends ResetState {
  final String message;
  ResetPasswordMessageSent(this.message) : super();

  @override
  String toString() => "ResetFormValidationSuccess";
}

class PasswordResetSuccess extends ResetState {
  final String message;
  PasswordResetSuccess(this.message) : super();

  @override
  String toString() => "PasswordResetSuccess";
}

class PasswordResetFailure extends ResetState {
  final String message;
  PasswordResetFailure(this.message) : super();

  @override
  String toString() => "PasswordResetFailure";
}

class ResetFormValidationFailure extends ResetState {
  ResetFormValidationFailure() : super();

  @override
  String toString() => "ResetFormValidationFailure";
}
