import 'package:chadbot/core/domain/repositories/user_repository.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

/// This use case is for when user needs to reset password
/// an email link will be sent to users email address if request succeeds
class SendResetPasswordOtp implements UseCase<void, String> {
  UserRepository userRepository;
  SendResetPasswordOtp(this.userRepository);

  @override
  Future<Either<Failure, void>> call(String email) async {
    return userRepository.sendPasswordResetEmail(email);
  }
}
