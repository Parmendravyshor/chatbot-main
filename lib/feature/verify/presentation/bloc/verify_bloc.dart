import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/domain/usecases/resend_verification_code.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:chadbot/feature/login/domain/usecases/email_signin.dart';
import 'package:chadbot/feature/verify/domain/usecases/create_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/get_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/verify_code.dart';
import 'package:chadbot/feature/verify/presentation/bloc/verify_event.dart';
import 'package:chadbot/feature/verify/presentation/bloc/verify_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:fluttertoast/fluttertoast.dart';

/// Bloc for Register page
///
class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final ResendCode _resendCode;
  final VerifyCode _verifyCode;
  final EmailSignin emailSignin;
  final SaveProfile saveProfile;
  final CreateProfile createProfile;

  VerifyBloc(this._resendCode, this._verifyCode, this.emailSignin,
      this.saveProfile, this.createProfile)
      : super(VerifyInitial());

  @override
  Stream<VerifyState> mapEventToState(VerifyEvent event) async* {
    if (event is CodeEntered) {
      yield VerifyOtpInProgress();
      final res = await _verifyCode(VerifyParams(event.code, event.email));
      if (res.isRight()) {
        final result = await emailSignin(EmailAuthParams(
            email: event.email,
            password: event.password,
            fName: "",
            lName: ""));
        if (result.isRight()) {
          final create = await createProfile(NoParams());
          if (create.isRight()) {
            await saveProfile(ProfileParams(
              email: event.email,
              fname: event.fname,
              lname: event.lname,
              phone: "",
              chadbotname: "My Kompanion",
              chadbotGender: "",
            ));
          }
          yield VerifyOtpSuccess();
        } else {
          yield VerifyOtpFailure(
              "Something wrong happened..please try again later");
        }
      } else {
        yield VerifyOtpFailure("Invalid OTP code");
      }
    } else if (event is ResendButtonTapped) {
      yield ResendOtpInProgress();
      final res = await _resendCode(event.email);
      if (res.isRight()) {
        yield ResendOtpSuccess();
      } else {
        yield ResendOtpFailure("Resend OTP failed.. please try again later");
      }
    }
  }
}
