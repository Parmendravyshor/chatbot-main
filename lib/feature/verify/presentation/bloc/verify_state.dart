abstract class VerifyState {
  VerifyState();
}

class VerifyInitial extends VerifyState {
  VerifyInitial() : super();

  @override
  String toString() => "VerifyInitial";
}

class VerifyOtpInProgress extends VerifyState {
  VerifyOtpInProgress() : super();

  @override
  String toString() => "VerifyOtpInProgress";
}

class VerifyOtpSuccess extends VerifyState {
  VerifyOtpSuccess() : super();

  @override
  String toString() => "VerifyOtpSuccess";
}

class VerifyOtpFailure extends VerifyState {
  final String message;
  VerifyOtpFailure(this.message) : super();

  @override
  String toString() => "VerifyOtpFailure";
}

class ResendOtpInProgress extends VerifyState {
  ResendOtpInProgress() : super();

  @override
  String toString() => "ResendOtpInProgress";
}

class ResendOtpSuccess extends VerifyState {
  ResendOtpSuccess() : super();

  @override
  String toString() => "ResendOtpSuccess";
}

class ResendOtpFailure extends VerifyState {
  final String message;
  ResendOtpFailure(this.message) : super();

  @override
  String toString() => "ResendOtpFailure";
}
