import 'package:chadbot/core/domain/repositories/user_repository.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

/// This class is responsible for Signup using Email and Password.
/// There will be different usecase for EmailLogin because logging in also
/// needs to check ShowAccount to actually register new PrivateKey.
class CreateProfile implements UseCase<void, void> {
  UserRepository userRepository;
  CreateProfile(this.userRepository);

  @override
  Future<Either<Failure, void>> call(void params) async {
    return userRepository.createProfile();
  }
}
