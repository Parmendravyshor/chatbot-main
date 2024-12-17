import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if Biometric Auth is available
  Future<bool> checkBiometricSupport() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      print("Biometric check error: $e");
      return false;
    }
  }

  /// Authenticate using Biometrics
  Future<bool> authenticateUser() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to proceed',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error during authentication: $e");
      return false;
    }
  }
}
