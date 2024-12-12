abstract class RegisterState {
  RegisterState();
}

class ResgiterInitial extends RegisterState {
  ResgiterInitial() : super();

  @override
  String toString() => "ResgiterInitial";
}

class RegisterInProgress extends RegisterState {
  RegisterInProgress() : super();

  @override
  String toString() => "RegisterInProgress";
}

class RegisterSuccess extends RegisterState {
  RegisterSuccess() : super();

  @override
  String toString() => "RegisterSuccess";
}

class RegisterFailure extends RegisterState {
  final String errorMessage;
  RegisterFailure(this.errorMessage) : super();
  @override
  String toString() => "RegisterFailure";
}

class RegisterFormValidationSuccess extends RegisterState {
  RegisterFormValidationSuccess() : super();

  @override
  String toString() => "RegisterFormValidationSuccess";
}

class RegisterFormValidationFailure extends RegisterState {
  RegisterFormValidationFailure() : super();

  @override
  String toString() => "RegisterFormValidationFailure";
}
