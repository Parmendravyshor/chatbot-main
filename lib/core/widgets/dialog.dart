import 'dart:ui';
import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title, descriptions, text;
  final Image? img;

  const CustomDialogBox(
      {Key? key, this.title, this.descriptions, this.text, this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10, top: 30, right: 10, bottom: 10),
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: ChadbotStyle.colors.cardbg,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title!, style: ChadbotStyle.text.small),
              SizedBox(
                height: 15,
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: TextField(
                  onChanged: (val) {},
                  textAlign: TextAlign.start,
                  controller: _controller,
                  maxLines: null,
                  style: ChadbotStyle.text.small,
                  decoration: InputDecoration(
                    hintText: 'Endpoint without https://',
                    hintStyle: ChadbotStyle.text.small,
                    border: ChadbotStyle.defaultBorder,
                    enabledBorder: ChadbotStyle.defaultBorder,
                    focusedBorder: ChadbotStyle.defaultBorder,
                  ),
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        KiwiContainer().resolve<SharedPrefHelper>().saveString(
                            ChadbotConstants.chatEndPoint, _controller.text);
                        _controller.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      widget.text!,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
