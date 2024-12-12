import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/domain/repositories/user_repository.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

/// This class is responsible for Signup using Email and Password.
/// There will be different usecase for EmailLogin because logging in also
/// needs to check ShowAccount to actually register new PrivateKey.
class EmailSignup implements UseCase<void, EmailAuthParams> {
  UserRepository userRepository;
  EmailSignup(this.userRepository);

  @override
  Future<Either<Failure, void>> call(EmailAuthParams params) async {
    return userRepository.emailSignup(params);
  }
}
