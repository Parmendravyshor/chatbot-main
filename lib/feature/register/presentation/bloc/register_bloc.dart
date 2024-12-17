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

  RegisterBloc(this._emailSignup) : super(ResgiterInitial()) {
    // Handle First Name Change
    on<FNameChanged>((event, emit) {
      if (event.name.isNotEmpty) {
        fname = event.name;
      } else {
        fname = "";
      }
      _validateForm(emit);
    });

    // Handle Last Name Change
    on<LNameChanged>((event, emit) {
      if (event.name.isNotEmpty) {
        lname = event.name;
      } else {
        lname = "";
      }
      _validateForm(emit);
    });

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

    // Handle Register Button Tapped
    on<RegisterButtonTapped>((event, emit) async {
      emit(RegisterInProgress());
      final result = await _emailSignup(EmailAuthParams(
          email: email, password: password, fName: fname, lName: lname));
      result.fold(
        (failure) =>
            emit(RegisterFailure("Signup failed..please try again.. $failure")),
        (_) => emit(RegisterSuccess()),
      );
    });
  }

  String fname = "";
  String lname = "";
  String email = "";
  String password = "";

  // Helper method for form validation
  void _validateForm(Emitter<RegisterState> emit) {
    if (_isFormValid()) {
      emit(RegisterFormValidationSuccess());
    } else {
      emit(RegisterFormValidationFailure());
    }
  }

  bool _isFormValid() {
    return fname.isNotEmpty &&
        lname.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty;
  }
}
