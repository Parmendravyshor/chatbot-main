import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _ChadbotColors {
  final bool _darkTheme;
  _ChadbotColors(this._darkTheme);
  Color whiteColor = Color(0xFFE5E5E5);
  Color darkColor = Color(0xFF171819);
  Color textColorWhite = Color(0xffffffff);
  Color textColorBlack = Color(0xff0000000);
  Color darkGrey = Color(0xffA1A6AB);
  Color lightGrey = Color(0xffD5D9DE);
  Color snowGrey = Color(0xFFF0F2F5);
  Color greyNight = Color(0xffE1E9F0);
  Color greyNight500 = Color(0xff6B7075);
  Color greyNight600 = Color(0xff404952);
  Color greyNight800 = Color(0xff1C2024);
  Color greyDay100 = Color(0xff171819);
  Color greyDay800 = Color(0xffF7FAFC);
  Color greyDay600 = Color(0xffD5D9DE);
  Color green = Color(0xff2B954C); // Green color for buttons
  Color greenAccent = Color(0x336de793); // Green border highlight for buttons
  Color dotIndicator = Color(0xff404952);
  Color navyBlue = Color(0xff3f37c9);
  Color enableButtonColor = Color(0xffFF6D42);
  Color bottomBg = Color(0xffFAFBFF);
  Color borderColor = Color(0xffD8D8D8);

  Color get formFieldBorder =>
      _darkTheme ? greyNight.withOpacity(0.1) : darkColor.withOpacity(0.1);
  Color get formFieldFill => _darkTheme ? darkColor : whiteColor;

  Color get buttonDisabled => _darkTheme ? Color(0xff1c2024) : lightGrey;
  Color get textDisabled => _darkTheme ? Color(0xff6b7075) : darkGrey;

  Color get cardbg => _darkTheme ? greyNight800 : greyDay800;

  Color get modalBg => _darkTheme
      ? Color(0xE1E9F0).withOpacity(0.1)
      : Color(0xF0F2F5).withOpacity(0.9);
  Color get divider => _darkTheme ? Color(0x0DE1E9F0) : Color(0xFFD5D9DE);
}

class _ChadbotTextStyles {
  final bool _darkTheme;

  _ChadbotTextStyles(this._darkTheme);

  TextStyle get tiniest {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 13,
        color: _darkTheme
            ? _ChadbotColors(_darkTheme).textColorWhite
            : _ChadbotColors(_darkTheme).textColorBlack);
  }

  TextStyle get tiny {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 15,
        color: _darkTheme
            ? _ChadbotColors(_darkTheme).textColorWhite
            : _ChadbotColors(_darkTheme).textColorBlack);
  }

  TextStyle get small {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 17,
        color: _darkTheme
            ? _ChadbotColors(_darkTheme).textColorWhite
            : _ChadbotColors(_darkTheme).textColorBlack);
  }

  TextStyle get medium {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 20,
        color: _darkTheme
            ? _ChadbotColors(_darkTheme).textColorWhite
            : _ChadbotColors(_darkTheme).textColorBlack);
  }

  TextStyle get large {
    return TextStyle(
        fontWeight: FontWeight.w700,
        fontFamily: 'Quicksand',
        fontSize: 25,
        color: _darkTheme
            ? ChadbotStyle.colors.textColorWhite
            : ChadbotStyle.colors.textColorBlack);
  }

  TextStyle get xlarge {
    return TextStyle(
        fontWeight: FontWeight.w700,
        fontFamily: 'Quicksand',
        fontSize: 34,
        color: _darkTheme
            ? ChadbotStyle.colors.textColorWhite
            : ChadbotStyle.colors.textColorBlack);
  }

  TextStyle get tinyDisable {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 13,
        color: _darkTheme
            ? ChadbotStyle.colors.greyNight500
            : ChadbotStyle.colors.greyDay100);
  }

  TextStyle get smallDisable {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 15,
        color: _darkTheme
            ? ChadbotStyle.colors.greyNight500
            : ChadbotStyle.colors.greyDay100);
  }

  TextStyle get mediumDisable {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 20,
        color: _darkTheme
            ? ChadbotStyle.colors.greyNight500
            : ChadbotStyle.colors.greyDay100);
  }

  TextStyle get actionBar {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 20,
        color: _darkTheme
            ? ChadbotStyle.colors.textColorWhite
            : ChadbotStyle.colors.textColorBlack);
  }

  TextStyle get mediumButton {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 16,
        color: ChadbotStyle.colors.textColorWhite);
  }

  TextStyle get smallGreen {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 15,
        color: ChadbotStyle.colors.green);
  }

  TextStyle get mediumGreen {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Quicksand',
        fontSize: 20,
        color: ChadbotStyle.colors.green);
  }
}

class ChadbotStyle {
  static bool _isDarkTheme = false;

  static _ChadbotColors get colors => _ChadbotColors(_isDarkTheme);
  static _ChadbotTextStyles get text => _ChadbotTextStyles(_isDarkTheme);

  static get buttonShapeEnabled => RoundedRectangleBorder(
      side: BorderSide(color: colors.enableButtonColor, width: 1),
      borderRadius: BorderRadius.circular(2));

  static get buttonShapeDisabled => RoundedRectangleBorder(
      side: BorderSide(color: colors.greyNight600.withOpacity(0.25), width: 1),
      borderRadius: BorderRadius.circular(2));

  static get buttonShadow => _isDarkTheme
      ? BoxDecoration(borderRadius: BorderRadius.circular(22.5), boxShadow: [])
      : null;

  /// Text field borders for focused and default
  ///
  static final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(2),
      borderSide: BorderSide(color: colors.formFieldBorder));

  static get focusedBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(2),
      borderSide: BorderSide(color: colors.formFieldBorder));

  static List<BoxShadow> focusedShadow = [
    BoxShadow(color: colors.whiteColor.withOpacity(0.2), spreadRadius: 3)
  ];

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    _isDarkTheme = isDarkTheme;
    return ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: Colors.transparent,
      ),
      primarySwatch: Colors.grey,
    );
  }
}
