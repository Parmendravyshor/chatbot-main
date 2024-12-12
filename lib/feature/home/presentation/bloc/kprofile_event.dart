/// Events class for Chat screen
abstract class KProfileEvent {
  KProfileEvent();
}

/// Chat Opened
///
/// This event is fired when Chat is opened
class KProfileOpened extends KProfileEvent {
  KProfileOpened();

  @override
  String toString() => "ProfileOpened";
}

/// Chat Opened
///
/// This event is fired when Chat is opened
class KSubmitProfileTapped extends KProfileEvent {
  final String kname;
  final String kgender;
  KSubmitProfileTapped(this.kname, this.kgender);

  @override
  String toString() => "KSubmitProfileTapped";
}
