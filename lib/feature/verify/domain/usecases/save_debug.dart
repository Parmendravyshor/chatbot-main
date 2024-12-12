import 'package:chadbot/core/domain/repositories/user_repository.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:dartz/dartz.dart';

/// This class is responsible for Signup using Email and Password.
/// There will be different usecase for EmailLogin because logging in also
/// needs to check ShowAccount to actually register new PrivateKey.
class SaveDebug implements UseCase<void, ProfileParams> {
  UserRepository userRepository;
  SaveDebug(this.userRepository);

  @override
  Future<Either<Failure, void>> call(ProfileParams params) async {
    return userRepository.saveDebug(params);
  }
}
