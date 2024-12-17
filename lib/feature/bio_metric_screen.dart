import 'package:chadbot/core/data/datasources/bio_metric_auth.dart';
import 'package:flutter/material.dart';

import 'home/presentation/home.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({Key? key}) : super(key: key);

  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final BiometricAuthService _biometricAuthService = BiometricAuthService();
  bool _biometricSupported = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    final isSupported = await _biometricAuthService.checkBiometricSupport();
    setState(() {
      _biometricSupported = isSupported;
    });
  }

  Future<void> _authenticate() async {
    final isAuthenticated = await _biometricAuthService.authenticateUser();
    if (isAuthenticated) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomeScreen();
      }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Authentication"),
      ),
      body: _biometricSupported
          ? Center(
              child: ElevatedButton(
                onPressed: _authenticate,
                child: const Text("Authenticate with Biometrics"),
              ),
            )
          : const Center(
              child: Text(
                "Biometric Authentication not supported on this device",
              ),
            ),
    );
  }
}
