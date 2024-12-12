/// Events class for Register screen
abstract class ResetEvent {
  ResetEvent();
}

/// Register Opened
///
/// This event is fired when register is opened
class ResetOpened extends ResetEvent {
  ResetOpened();

  @override
  String toString() => "ResetOpened";
}

/// Register Button Tapped
///
/// This event is fired when Register button is tapped
class ResetButtonTapped extends ResetEvent {
  ResetButtonTapped();

  @override
  String toString() => "ResetButtonTapped";
}

/// Register Button Tapped
///
/// This event is fired when Register button is tapped
class SetNewPasswordTapped extends ResetEvent {
  final String otp;
  final String password;
  SetNewPasswordTapped(this.otp, this.password);

  @override
  String toString() => "SetNewPasswordTapped";
}

/// Email Changed
///
/// This event is fired when Email is changed
class EmailChanged extends ResetEvent {
  final String email;
  EmailChanged(this.email);

  @override
  String toString() => "EmailChanged";
}
