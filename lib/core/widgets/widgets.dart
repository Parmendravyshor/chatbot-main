import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/theme/style.dart';
import 'package:flutter/material.dart';

/// This is a widget that will be used for displaying header titles
class HeaderText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  HeaderText(this.text, {this.textAlign = TextAlign.center});
  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: textAlign, style: ChadbotStyle.text.medium);
  }
}

/// This will be used by any description that goes below header.
class BodyText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  BodyText(this.text, {this.textAlign = TextAlign.center});
  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: textAlign, style: ChadbotStyle.text.small);
  }
}

class ThemedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool enabled;

  const ThemedButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.enabled = true})
      : super(key: key);

  Widget build(context) {
    final enabledColor = ChadbotStyle.colors.enableButtonColor;
    final disabledColor = ChadbotStyle.colors.buttonDisabled;

    final enabledTextColor = ChadbotStyle.colors.whiteColor;
    final disabledTextColor = ChadbotStyle.colors.textDisabled;
    return Center(
        child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Container(
                decoration: enabled ? ChadbotStyle.buttonShadow : null,
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, ButtonMinHeight),
                    shape: enabled
                        ? ChadbotStyle.buttonShapeEnabled
                        : ChadbotStyle.buttonShapeDisabled,
                    backgroundColor: enabled ? enabledColor : disabledColor,
                    padding: EdgeInsets.all(8.0),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: ChadbotStyle.text.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: enabled ? enabledTextColor : disabledTextColor,
                    ),
                  ),
                ))));
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool enabled;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.enabled = true})
      : super(key: key);

  Widget build(context) {
    final enabledTextColor = ChadbotStyle.colors.enableButtonColor;
    return FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
            decoration: BoxDecoration(color: ChadbotStyle.colors.cardbg),
            child: ElevatedButton(
                // minWidth: double.infinity,
                // height: ButtonMinHeight,
                // shape: ChadbotStyle.buttonShapeEnabled,
                // color: ChadbotStyle.colors.whiteColor,
                // textColor: Colors.white,
                // padding: EdgeInsets.all(8.0),
                onPressed: onPressed,
                child: Text(text,
                    style: ChadbotStyle.text.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: enabledTextColor)))));
  }
}
