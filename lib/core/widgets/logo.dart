import 'package:flutter/material.dart';

/// This Widget is for Toplogo images in center above login.signup,reset pages, with given asset path
class TopLogo extends StatelessWidget {
  final String assetPath;
  TopLogo(this.assetPath);
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        child: Image(
      width: 100,
      height: 100,
      fit: BoxFit.contain,
      image: AssetImage(assetPath),
    ));
  }
}
