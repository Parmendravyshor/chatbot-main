abstract class ProfileState {
  ProfileState();
}

class ProfileSaveInitial extends ProfileState {
  ProfileSaveInitial() : super();

  @override
  String toString() => "ProfileSaveInitial";
}

class ProfileSaveInProgress extends ProfileState {
  ProfileSaveInProgress() : super();

  @override
  String toString() => "ProfileSaveInProgress";
}

class ProfileSaveSuccess extends ProfileState {
  ProfileSaveSuccess() : super();

  @override
  String toString() => "ProfileSaveSuccess";
}

class ProfileSaveFailure extends ProfileState {
  final String errorMessage;
  ProfileSaveFailure(this.errorMessage) : super();
  @override
  String toString() => "ProfileSaveFailure";
}
