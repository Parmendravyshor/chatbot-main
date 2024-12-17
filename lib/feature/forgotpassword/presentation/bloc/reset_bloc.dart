import 'package:chadbot/feature/forgotpassword/domain/usecases/reset_password.dart';
import 'package:chadbot/feature/forgotpassword/domain/usecases/send_reset_otp.dart';
import 'package:chadbot/feature/forgotpassword/presentation/bloc/reset_event.dart';
import 'package:chadbot/feature/forgotpassword/presentation/bloc/reset_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:fluttertoast/fluttertoast.dart';

/// Bloc for Register page
///
class ResetBloc extends Bloc<ResetEvent, ResetState> {
  final SendResetPasswordOtp _sendResetPwdOtp;
  final ResetPassword _resetpwd;

  ResetBloc(this._sendResetPwdOtp, this._resetpwd) : super(ResetInitial()) {
    // Registering handlers
    on<EmailChanged>(_onEmailChanged);
    on<ResetButtonTapped>(_onResetButtonTapped);
    on<SetNewPasswordTapped>(_onSetNewPasswordTapped);
  }

  String email = "";
  int step = 1;

  /// Handler for EmailChanged Event
  Future<void> _onEmailChanged(
      EmailChanged event, Emitter<ResetState> emit) async {
    if (event.email.isNotEmpty && EmailValidator.validate(event.email)) {
      email = event.email;
      emit(ResetFormValidationSuccess());
    } else {
      email = "";
      emit(ResetFormValidationFailure());
    }
  }

  /// Handler for ResetButtonTapped Event
  Future<void> _onResetButtonTapped(
      ResetButtonTapped event, Emitter<ResetState> emit) async {
    emit(ResetInProgress());
    final result = await _sendResetPwdOtp.call(email);

    result.fold(
      (failure) {
        emit(ResetFailure(
            "Failed to send reset password link. Please try again."));
      },
      (success) {
        step = 2;
        emit(
            ResetPasswordMessageSent("Password reset link sent to your email"));
      },
    );
  }

  /// Handler for SetNewPasswordTapped Event
  Future<void> _onSetNewPasswordTapped(
      SetNewPasswordTapped event, Emitter<ResetState> emit) async {
    emit(ResetInProgress());

    final result = await _resetpwd.call(SetNewPasswordParams(
      email: email,
      otp: event.otp,
      password: event.password,
    ));

    result.fold(
      (failure) {
        emit(ResetFailure("Failed to reset password. Please try again."));
      },
      (success) {
        emit(ResetPasswordMessageSent(
            "Password reset successfully. You can now log in."));
      },
    );
  }
}
