/// Events class for Register screen
abstract class RegisterEvent {
  RegisterEvent();
}

/// Register Opened
///
/// This event is fired when register is opened
class RegisterOpened extends RegisterEvent {
  RegisterOpened();

  @override
  String toString() => "RegisterOpened";
}

/// Register Button Tapped
///
/// This event is fired when Register button is tapped
class RegisterButtonTapped extends RegisterEvent {
  RegisterButtonTapped();

  @override
  String toString() => "RegisterButtonTapped";
}

/// Name Changed
///
/// This event is fired when Name is changed
class FNameChanged extends RegisterEvent {
  final String name;
  FNameChanged(this.name);

  @override
  String toString() => "NameChanged";
}

/// Name Changed
///
/// This event is fired when Name is changed
class LNameChanged extends RegisterEvent {
  final String name;
  LNameChanged(this.name);

  @override
  String toString() => "NameChanged";
}

/// Email Changed
///
/// This event is fired when Email is changed
class EmailChanged extends RegisterEvent {
  final String email;
  EmailChanged(this.email);

  @override
  String toString() => "EmailChanged";
}

/// Password Changed
///
/// This event is fired when password is changed
class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged(this.password);

  @override
  String toString() => "PasswordChanged";
}
