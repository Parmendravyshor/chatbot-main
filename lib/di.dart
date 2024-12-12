import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/data/datasources/storage.dart';
import 'package:chadbot/core/data/repositories/user_repository_impl.dart';
import 'package:chadbot/core/domain/repositories/user_repository.dart';
import 'package:chadbot/core/domain/usecases/resend_verification_code.dart';
import 'package:chadbot/feature/chat/domain/usecases/get_text_file.dart';
import 'package:chadbot/feature/chat/presentation/bloc/chat_bloc.dart';
import 'package:chadbot/feature/forgotpassword/domain/usecases/reset_password.dart';
import 'package:chadbot/feature/forgotpassword/domain/usecases/send_reset_otp.dart';
import 'package:chadbot/feature/forgotpassword/presentation/bloc/reset_bloc.dart';
import 'package:chadbot/feature/home/presentation/bloc/kprofile_bloc.dart';
import 'package:chadbot/feature/home/presentation/bloc/profile_bloc.dart';
import 'package:chadbot/feature/login/presentation/bloc/login_bloc.dart';
import 'package:chadbot/feature/register/domain/usecases/email_signup.dart';
import 'package:chadbot/feature/register/presentation/bloc/register_bloc.dart';
import 'package:chadbot/feature/verify/domain/usecases/create_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/delete_cognito.dart';
import 'package:chadbot/feature/verify/domain/usecases/delete_context.dart';
import 'package:chadbot/feature/verify/domain/usecases/delete_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/get_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_debug.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_registration_id.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_single_field.dart';
import 'package:chadbot/feature/verify/domain/usecases/verify_code.dart';
import 'package:chadbot/feature/verify/presentation/bloc/verify_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/data/datasources/auth_source.dart';
import 'core/data/datasources/user_service.dart';
import 'feature/login/domain/usecases/email_signin.dart';

Future<void> registerDependencyInjection() async {
  var container = KiwiContainer();

  await _registerMisc(container);
  await _registerApiClient(container);
  await _registerDataSources(container);
  _registerRepositories(container);
  _registerUseCases(container);
  _registerBloc(container);
}

void _registerBloc(KiwiContainer container) {
  container
      .registerFactory((c) => ChatBloc(c.resolve(), c.resolve(), c.resolve()));
  container.registerFactory((c) => RegisterBloc(c.resolve()));
  container.registerFactory(
      (c) => LoginBloc(c.resolve(), c.resolve(), c.resolve(), c.resolve()));
  container.registerFactory((c) => ResetBloc(c.resolve(), c.resolve()));
  container.registerFactory((c) => ProfileBloc(c.resolve(), c.resolve()));
  container.registerFactory((c) => KProfileBloc(c.resolve(), c.resolve()));
  container.registerFactory((c) => VerifyBloc(
      c.resolve(), c.resolve(), c.resolve(), c.resolve(), c.resolve()));
}

void _registerUseCases(KiwiContainer container) {
  container.registerFactory((c) => EmailSignin(c.resolve()));
  container.registerFactory((c) => EmailSignup(c.resolve()));
  container.registerFactory((c) => ResendCode(c.resolve()));
  container.registerFactory((c) => SendResetPasswordOtp(c.resolve()));
  container.registerFactory((c) => VerifyCode(c.resolve()));
  container.registerFactory((c) => GetTextFile(c.resolve()));
  container.registerFactory((c) => SaveProfile(c.resolve()));
  container.registerFactory((c) => GetProfile(c.resolve()));
  container.registerFactory((c) => CreateProfile(c.resolve()));
  container.registerFactory((c) => DeleteContext(c.resolve()));
  container.registerFactory((c) => DeleteProfile(c.resolve()));
  container.registerFactory((c) => DeleteCognitoAccount(c.resolve()));
  container.registerFactory((c) => SaveDebug(c.resolve()));
  container.registerFactory((c) => ResetPassword(c.resolve()));
  container.registerFactory((c) => SaveRegistrationId(c.resolve()));
  container.registerFactory((c) => SaveSingleField(c.resolve()));
}

void _registerRepositories(KiwiContainer container) {
  container.registerFactory<UserRepository>(
      (c) => UserRepositoryImpl(c.resolve(), c.resolve()));
}

_registerDataSources(KiwiContainer container) {
  container.registerFactory<AuthSource>(
      (c) => UserService(c.resolve(), c.resolve(), c.resolve()));
  container.registerFactory<SharedPrefHelper>(
      (c) => SharedPrefHelperImpl(c.resolve()));
}

_registerApiClient(KiwiContainer container) {}

_registerMisc(KiwiContainer container) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  container.registerFactory((c) => sharedPreferences);
  container.registerFactory((c) => Storage(sharedPreferences));
  container.registerFactory((c) =>
      new CognitoUserPool(ChadbotConstants.poolid, ChadbotConstants.clientid));
}
