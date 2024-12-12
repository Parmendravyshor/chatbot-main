import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/feature/chat/domain/entity/message.dart';
import 'package:chadbot/feature/home/presentation/bloc/kprofile_event.dart';
import 'package:chadbot/feature/home/presentation/bloc/kprofile_state.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc for CHhat page
///
class KProfileBloc extends Bloc<KProfileEvent, KProfileState> {
  List<Message> messageList = [];
  final SharedPrefHelper sharedPrefHelper;
  final SaveProfile saveProfile;
  KProfileBloc(this.sharedPrefHelper, this.saveProfile)
      : super(KProfileSaveInitial());

  @override
  Stream<KProfileState> mapEventToState(KProfileEvent event) async* {
    if (event is KProfileOpened) {
    } else if (event is KSubmitProfileTapped) {}
  }
}
