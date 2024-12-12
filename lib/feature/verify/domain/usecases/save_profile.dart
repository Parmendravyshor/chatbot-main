import 'package:chadbot/core/domain/repositories/user_repository.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

/// This class is responsible for Signup using Email and Password.
/// There will be different usecase for EmailLogin because logging in also
/// needs to check ShowAccount to actually register new PrivateKey.
class SaveProfile implements UseCase<void, ProfileParams> {
  UserRepository userRepository;
  SaveProfile(this.userRepository);

  @override
  Future<Either<Failure, void>> call(ProfileParams params) async {
    return userRepository.saveProfile(params);
  }
}

class ProfileParams {
  final String? email;
  final String? fname;
  final String? lname;
  final String? phone;
  final String? chadbotname;
  final String? chadbotGender;
  final int? contextlen;
  final int? contextprune;
  final bool? contextrand;
  final bool? contextoff;
  final bool? debug;
  final int? model;
  final int? topk;
  final double? temp;
  final double? topp;
  final double? repetition;

  final int? memories;
  final int? userpersona;
  final int? pokeTop;
  final int? pokeDelay;
  final String? lastseen;
  final String? lastpoked;

  ProfileParams({
    this.email,
    this.fname,
    this.lname,
    this.phone,
    this.chadbotname,
    this.chadbotGender,
    this.contextlen,
    this.contextprune,
    this.contextrand,
    this.contextoff,
    this.debug,
    this.model,
    this.topk,
    this.topp,
    this.temp,
    this.repetition,
    this.lastpoked,
    this.lastseen,
    this.memories,
    this.userpersona,
    this.pokeDelay,
    this.pokeTop,
  });
}
