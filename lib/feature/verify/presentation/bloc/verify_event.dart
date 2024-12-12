/// Events class for Register screen
abstract class VerifyEvent {
  VerifyEvent();
}

/// Register Opened
///
/// This event is fired when register is opened
class VerifyOpened extends VerifyEvent {
  VerifyOpened();

  @override
  String toString() => "VerifyOpened";
}

/// Register Button Tapped
///
/// This event is fired when Register button is tapped
class ResendButtonTapped extends VerifyEvent {
  final String email;
  ResendButtonTapped(this.email);

  @override
  String toString() => "RegisterButtonTapped";
}

/// Name Changed
///
/// This event is fired when Name is changed
class CodeEntered extends VerifyEvent {
  final String code;
  final String email;
  final String password;
  final String fname;
  final String lname;
  final bool isRegister;
  CodeEntered(this.code, this.email, this.password, this.fname, this.lname,
      this.isRegister);

  @override
  String toString() => "CodeEntered";
}
