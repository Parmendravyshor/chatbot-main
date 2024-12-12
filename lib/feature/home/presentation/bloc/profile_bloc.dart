import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/feature/home/presentation/bloc/profile_event.dart';
import 'package:chadbot/feature/home/presentation/bloc/profile_state.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc for CHhat page
///
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SharedPrefHelper sharedPrefHelper;
  final SaveProfile saveProfile;
  ProfileBloc(this.sharedPrefHelper, this.saveProfile)
      : super(ProfileSaveInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileOpened) {
    } else if (event is SubmitProfileTapped) {
      ProfileParams profileParams = ProfileParams(
        email: sharedPrefHelper.getEmail(),
        fname: event.fname,
        lname: event.lname,
        phone: event.phone,
        chadbotGender:
            sharedPrefHelper.getStringByKey(ChadbotConstants.chadbotGender, ""),
        chadbotname: sharedPrefHelper.getStringByKey(
            ChadbotConstants.chadbotName, "Chadbot"),
        contextlen:
            sharedPrefHelper.getIntByKey(ChadbotConstants.contextlen, 7),
        contextprune:
            sharedPrefHelper.getIntByKey(ChadbotConstants.contextprune, 0),
        contextoff:
            sharedPrefHelper.getBoolByKey(ChadbotConstants.contextoff, false),
        contextrand:
            sharedPrefHelper.getBoolByKey(ChadbotConstants.contextrand, false),
        debug: sharedPrefHelper.getBoolByKey(ChadbotConstants.debug, false),
      );

      final result = await saveProfile(profileParams);
      if (result.isRight()) {
        print("profileeee saveddd");
      } else {
        print("profileeee faileddd");
      }
      yield ProfileSaveSuccess();
    }
  }
}
