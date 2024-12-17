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
    this._emailSignin,
    this._resendCode,
    this.getprofile,
    this.createProfile,
  ) : super(LoginInitial()) {
    // Handle Email Change
    on<EmailChanged>((event, emit) {
      if (event.email.isNotEmpty && EmailValidator.validate(event.email)) {
        email = event.email;
      } else {
        email = "";
      }
      _validateForm(emit);
    });

    // Handle Password Change
    on<PasswordChanged>((event, emit) {
      if (event.password.isNotEmpty && event.password.length > 5) {
        password = event.password;
      } else {
        password = "";
      }
      _validateForm(emit);
    });

    // Handle Login Button Tap
    on<LoginButtonTapped>((event, emit) async {
      emit(LoginInProgress());

      final result = await _emailSignin.call(
        EmailAuthParams(
            email: email, password: password, fName: "Tes", lName: "Test"),
      );

      await result.fold(
        (failure) async {
          if (failure is UserNotConfirmedFailure) {
            final res = await _resendCode(email);
            if (res.isRight()) {
              emit(VerificationNeeded());
            } else {
              emit(LoginFailure("Resend code failed..please try again."));
            }
          } else {
            emit(LoginFailure("Signin failed..please try again.. $failure"));
          }
        },
        (_) async {
          await getprofile(NoParams());
          emit(LoginSuccess());
        },
      );
    });
  }

  String email = "";
  String password = "";

  void _validateForm(Emitter<LoginState> emit) {
    if (_isFormValid()) {
      emit(LoginFormValidationSuccess());
    } else {
      emit(LoginFormValidationFailure());
    }
  }

  bool _isFormValid() {
    return email.isNotEmpty && password.isNotEmpty;
  }
}
