import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/feature/register/domain/usecases/email_signup.dart';
import 'package:chadbot/feature/register/presentation/bloc/register_event.dart';
import 'package:chadbot/feature/register/presentation/bloc/register_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:fluttertoast/fluttertoast.dart';

/// Bloc for Register page
///
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final EmailSignup _emailSignup;
  RegisterBloc(this._emailSignup) : super(ResgiterInitial());
  String fname = "";
  String lname = "";
  String email = "";
  String password = "";

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is FNameChanged) {
      if (event.name.isNotEmpty) {
        fname = event.name;
      } else {
        fname = "";
      }
      bool isValidated = _isFormValid();
      if (isValidated) {
        yield RegisterFormValidationSuccess();
      } else {
        yield RegisterFormValidationFailure();
      }
    } else if (event is LNameChanged) {
      if (event.name.isNotEmpty) {
        lname = event.name;
      } else {
        lname = "";
      }
      bool isValidated = _isFormValid();
      if (isValidated) {
        yield RegisterFormValidationSuccess();
      } else {
        yield RegisterFormValidationFailure();
      }
    } else if (event is EmailChanged) {
      if (event.email.isNotEmpty && EmailValidator.validate(event.email)) {
        email = event.email;
      } else {
        email = "";
      }
      bool isValidated = _isFormValid();
      if (isValidated) {
        yield RegisterFormValidationSuccess();
      } else {
        yield RegisterFormValidationFailure();
      }
    } else if (event is PasswordChanged) {
      if (event.password.isNotEmpty && event.password.length > 5) {
        password = event.password;
      } else {
        password = "";
      }
      bool isValidated = _isFormValid();
      if (isValidated) {
        yield RegisterFormValidationSuccess();
      } else {
        yield RegisterFormValidationFailure();
      }
    } else if (event is RegisterButtonTapped) {
      yield RegisterInProgress();
      final result = await _emailSignup(EmailAuthParams(
          email: email, password: password, fName: "Pavan", lName: "Kumar"));
      yield* result.fold((l) async* {
        yield RegisterFailure("Signup failed..please try again.. $l");
      }, (r) async* {
        yield RegisterSuccess();
      });
    }
  }

  bool _isFormValid() {
    return fname.isNotEmpty &&
        lname.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty;
  }
}
