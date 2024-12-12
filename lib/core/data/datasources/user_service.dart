import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:chadbot/core/data/datasources/auth_source.dart';
import 'package:chadbot/core/data/datasources/storage.dart';
import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/feature/verify/domain/usecases/verify_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends AuthSource {
  final CognitoUserPool _userPool;
  final SharedPreferences prefs;
  final Storage storage;
  UserService(this._userPool, this.prefs, this.storage);

  /// Confirm user's account with confirmation code sent to email
  Future<bool> confirmAccount(String email, String confirmationCode) async {
    CognitoUser _cognitoUser =
        CognitoUser(email, _userPool, storage: _userPool.storage);

    return await _cognitoUser.confirmRegistration(confirmationCode);
  }

  /// Resend confirmation code to user's email
  @override
  Future<void> resendConfirmationCode(String email) async {
    CognitoUser _cognitoUser =
        CognitoUser(email, _userPool, storage: _userPool.storage);
    await _cognitoUser.resendConfirmationCode();
  }

  @override
  Future<bool> isValidSession() async {
    _userPool.storage = storage;

    CognitoUser? _cognitoUser = await _userPool.getCurrentUser();
    if (_cognitoUser == null) {
      return false;
    }
    CognitoUserSession? _session = await _cognitoUser.getSession();
    return _session!.isValid();
  }

  Future<CognitoUserSession> emailLogin(EmailAuthParams params) async {
    CognitoUser _cognitoUser =
        CognitoUser(params.email, _userPool, storage: _userPool.storage);

    final authDetails = AuthenticationDetails(
      username: params.email,
      password: params.password,
    );

    CognitoUserSession? session =
        await _cognitoUser.authenticateUser(authDetails);

    if (session == null) {
      throw Exception('Authentication failed');
    }

    return session;
  }

  @override
  Future<CognitoUserPoolData> emailSignup(EmailAuthParams params) {
    final userAttributes = [
      AttributeArg(name: 'email', value: params.email),
    ];
    try {
      return _userPool.signUp(params.email, params.password,
          userAttributes: userAttributes);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> verifyOtp(VerifyParams params) async {
    CognitoUser _cognitoUser =
        CognitoUser(params.email, _userPool, storage: _userPool.storage);
    return await _cognitoUser.confirmRegistration(params.code);
  }

  @override
  Future<void> sendResetEmail(String email) {
    CognitoUser _cognitoUser =
        CognitoUser(email, _userPool, storage: _userPool.storage);
    return _cognitoUser.forgotPassword();
  }

  @override
  Future<void> deleteAccount(String email, String token) async {
    CognitoUser _cognitoUser =
        CognitoUser(email, _userPool, storage: _userPool.storage);
    final paramsReq = {
      'AccessToken': token,
    };
    return await _cognitoUser.client!.request('DeleteUser', paramsReq);
  }

  @override
  Future<void> resetNewPassword(String email, String otp, String password) {
    CognitoUser _cognitoUser =
        CognitoUser(email, _userPool, storage: _userPool.storage);
    return _cognitoUser.confirmPassword(otp, password);
  }
}
