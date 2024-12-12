import 'package:chadbot/core/data/datasources/user.dart';
import 'package:chadbot/core/domain/repositories/user_repository.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

/// This class is responsible for Signin in using Email and Password.
///
class ResendEmail implements UseCase<void, String> {
  UserRepository userRepository;
  ResendEmail(this.userRepository);

  /// This will call [UserRepository] first to authenticate over firebase
  /// If authentication over firebase succeeds, it will Call [UserRepository] again to authenticate on triffic servers
  /// if any of above requests fails it will return [Failure] with message of cause
  @override
  Future<Either<Failure, void>> call(String email) async {
    return userRepository.sendPasswordResetEmail(email);
  }
}
