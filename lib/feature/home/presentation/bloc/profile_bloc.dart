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
      : super(ProfileSaveInitial()) {
    // Registering event handlers
    on<ProfileOpened>(_onProfileOpened);
    on<SubmitProfileTapped>(_onSubmitProfileTapped);
  }

  /// Handler for ProfileOpened Event
  Future<void> _onProfileOpened(
      ProfileOpened event, Emitter<ProfileState> emit) async {
    // emit(ProfileLoading());
    try {
      final email = sharedPrefHelper.getEmail();
      final chadbotName = sharedPrefHelper.getStringByKey(
          ChadbotConstants.chadbotName, "Chadbot");
      final chadbotGender =
          sharedPrefHelper.getStringByKey(ChadbotConstants.chadbotGender, "");
      final contextlen =
          sharedPrefHelper.getIntByKey(ChadbotConstants.contextlen, 7);
      final contextprune =
          sharedPrefHelper.getIntByKey(ChadbotConstants.contextprune, 0);
      final contextoff =
          sharedPrefHelper.getBoolByKey(ChadbotConstants.contextoff, false);
      final contextrand =
          sharedPrefHelper.getBoolByKey(ChadbotConstants.contextrand, false);
      final debug =
          sharedPrefHelper.getBoolByKey(ChadbotConstants.debug, false);

      // Build ProfileParams
      final profileParams = ProfileParams(
        email: email,
        fname: "",
        lname: "",
        phone: "",
        chadbotGender: chadbotGender,
        chadbotname: chadbotName,
        contextlen: contextlen,
        contextprune: contextprune,
        contextoff: contextoff,
        contextrand: contextrand,
        debug: debug,
      );

      // emit(ProfileLoadSuccess(profileParams));
    } catch (e) {
      // emit(ProfileLoadFailure("Failed to load profile: ${e.toString()}"));
    }
  }

  /// Handler for SubmitProfileTapped Event
  Future<void> _onSubmitProfileTapped(
      SubmitProfileTapped event, Emitter<ProfileState> emit) async {
    emit(ProfileSaveInProgress());

    try {
      // Building profile parameters from shared preferences and event data
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

      result.fold(
        (failure) => emit(ProfileSaveFailure("Failed to save profile.")),
        (success) => emit(ProfileSaveSuccess()),
      );
    } catch (e) {
      emit(ProfileSaveFailure("Error occurred: ${e.toString()}"));
    }
  }
}
