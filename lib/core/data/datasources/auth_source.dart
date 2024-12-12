import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/errors/exceptions.dart';
import 'package:chadbot/feature/verify/domain/usecases/verify_code.dart';

class UserNotFoundAuthException extends AuthException {}

class BadCredentialsAuthException extends AuthException {}

class EmailAlreadyInUseAuthException extends AuthException {}

/// This class provides basic starting point for any kind of [AuthSource]
/// Any class that implements has to implement their own signup method
/// to become an [AuthSource]. When user is successfully created on remote,
/// this will return [UserCredentials] on success or throw [Exception]
/// finishSignup step which actually creates user on Triffic Servers will use
/// the credentials from local disk after this is called.
abstract class AuthSource {
  Future<CognitoUserPoolData> emailSignup(EmailAuthParams params);
  Future<CognitoUserSession> emailLogin(EmailAuthParams params);
  Future<void> sendResetEmail(String email);
  Future<void> resetNewPassword(String email, String otp, String password);
  Future<void> resendConfirmationCode(String email);
  Future<void> deleteAccount(String email, String token);
  Future<bool> verifyOtp(VerifyParams params);
  Future<bool> isValidSession();
}
