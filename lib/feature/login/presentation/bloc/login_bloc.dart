import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/domain/usecases/resend_verification_code.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:chadbot/feature/login/domain/usecases/email_signin.dart';
import 'package:chadbot/feature/login/presentation/bloc/login_event.dart';
import 'package:chadbot/feature/login/presentation/bloc/login_state.dart';
import 'package:chadbot/feature/verify/domain/usecases/create_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/get_profile.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:fluttertoast/fluttertoast.dart';

/// Bloc for Register page
///
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final EmailSignin _emailSignin;
  final ResendCode _resendCode;
  final GetProfile getprofile;
  final CreateProfile createProfile;

  LoginBloc(
      this._emailSignin, this._resendCode, this.getprofile, this.createProfile)
      : super(LoginInitial());
  String email = "";
  String password = "";

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      if (event.email.isNotEmpty && EmailValidator.validate(event.email)) {
        email = event.email;
      } else {
        email = "";
      }
      bool isValidated = _isFormValid();
      if (isValidated) {
        yield LoginFormValidationSuccess();
      } else {
        yield LoginFormValidationFailure();
      }
    } else if (event is PasswordChanged) {
      if (event.password.isNotEmpty && event.password.length > 5) {
        password = event.password;
      } else {
        password = "";
      }
      bool isValidated = _isFormValid();
      if (isValidated) {
        yield LoginFormValidationSuccess();
      } else {
        yield LoginFormValidationFailure();
      }
    } else if (event is LoginButtonTapped) {
      yield LoginInProgress();
      final result = await _emailSignin.call(EmailAuthParams(
          email: email, password: password, fName: "Tes", lName: "Test"));
      yield* result.fold((l) async* {
        if (l is UserNotConfirmedFailure) {
          final res = await _resendCode(email);
          if (res.isRight()) {
            yield VerificationNeeded();
          } else {
            yield LoginFailure("Signin failed..please try again.. $l");
          }
        } else {
          yield LoginFailure("Signin failed..please try again.. $l");
        }
        //yield LoginFailure("Signin failed..please try again.. $l");
      }, (r) async* {
        await getprofile(NoParams());
        yield LoginSuccess();
      });
    }
  }

  bool _isFormValid() {
    return email.isNotEmpty && password.isNotEmpty;
  }
}
