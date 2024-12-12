/// Events class for Chat screen
abstract class ProfileEvent {
  ProfileEvent();
}

/// Chat Opened
///
/// This event is fired when Chat is opened
class ProfileOpened extends ProfileEvent {
  ProfileOpened();

  @override
  String toString() => "ProfileOpened";
}

/// Chat Opened
///
/// This event is fired when Chat is opened
class SubmitProfileTapped extends ProfileEvent {
  final String fname;
  final String lname;
  final String phone;
  SubmitProfileTapped(this.fname, this.lname, this.phone);

  @override
  String toString() => "SubmitProfileTapped";
}
