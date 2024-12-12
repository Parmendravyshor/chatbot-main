import 'dart:io';

import 'package:chadbot/core/data/datasources/user.dart';
import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_single_field.dart';
import 'package:chadbot/feature/verify/domain/usecases/verify_code.dart';
import 'package:dartz/dartz.dart';

/// This Repository will handle functions related to gettting user account
/// and logout user
abstract class UserRepository<T> {
  Future<Either<Failure, void>> emailSignup(EmailAuthParams params);
  Future<Either<Failure, void>> emailLogin(EmailAuthParams params);
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> setNewPassword(
      {String email, String otp, String password});
  Future<Either<Failure, void>> resendOtp(String email);
  Future<Either<Failure, void>> verifyCode(VerifyParams email);
  Future<Either<Failure, void>> saveProfile(ProfileParams email);
  Future<Either<Failure, void>> saveDebug(ProfileParams email);
  Future<Either<Failure, void>> getProfile();
  Future<Either<Failure, void>> createProfile();
  Future<Either<Failure, void>> deleteProfile();
  Future<Either<Failure, void>> deleteContext();
  Future<Either<Failure, void>> deleteCognitoAccount();
  Future<Either<Failure, void>> saveRegistrationId();
  Future<Either<Failure, File>> getTextFile(String chatText);
  Future<Either<Failure, void>> saveSingleField(SingleProfileParam params);
}
