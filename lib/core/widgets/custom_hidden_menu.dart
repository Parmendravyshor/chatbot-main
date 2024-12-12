import 'dart:ui';
import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:chadbot/core/widgets/themed_text_field.dart';
import 'package:chadbot/feature/login/domain/usecases/email_signin.dart';
import 'package:chadbot/feature/verify/domain/usecases/delete_context.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_debug.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class CustomHiddeniMenu extends StatefulWidget {
  final String? title, descriptions, text;
  final Image? img;

  const CustomHiddeniMenu(
      {Key? key, this.title, this.descriptions, this.text, this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomHiddeniMenu> {
  bool _debug = false;
  bool _contextoff = false;
  bool _contextprune = false;
  bool _contextrand = false;
  TextEditingController _controller = TextEditingController();
  int _dropDownValue = 0;
  String _selValue = "DialoGPT-Large";
  SharedPrefHelper _sharedPrefHelper =
      KiwiContainer().resolve<SharedPrefHelper>();
  TextEditingController _textEditingController = TextEditingController();
  SaveDebug _saveProfile = KiwiContainer().resolve<SaveDebug>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _textEditingController = TextEditingController();
    _dropDownValue = _sharedPrefHelper.getIntByKey(ChadbotConstants.model, 0);

    switch (_dropDownValue) {
      case 0:
        _selValue = "DialoGPT-Medium";
        break;
      case 1:
        _selValue = "DialoGPT-Large";
        break;
      case 2:
        _selValue = "DialogBERT-Large";
        break;
      case 3:
        _selValue = "DistilBERT-MSMARCO";
        break;
      case 4:
        _selValue = "DistilBERT-Google";
        break;
      case 5:
        _selValue = "T5";
        break;
      case 6:
        _selValue = "GPT-3";
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _textEditingController.dispose();
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
          padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
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
              DropdownButton(
                hint: Text(
                  _selValue,
                  style: ChadbotStyle.text.small,
                ),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(color: Colors.blue),
                items: [
                  'DialoGPT-Medium',
                  'DialoGPT-Large',
                  'DialogBERT-Large',
                  'DistilBERT-MSMARCO',
                  'DistilBERT-Google',
                  'T5',
                  'GPT-3',
                ].map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val, style: ChadbotStyle.text.small),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      _selValue = val.toString();
                      if (val == "DialoGPT-Large") {
                        _dropDownValue = 1;
                      }
                      if (val == "DialoGPT-Medium") {
                        _dropDownValue = 0;
                      }

                      if (val == "DialogBERT-Large") {
                        _dropDownValue = 2;
                      }

                      if (val == "DistilBERT-MSMARCO") {
                        _dropDownValue = 3;
                      }
                      if (val == "DistilBERT-Google") {
                        _dropDownValue = 4;
                      }
                      if (val == "T5") {
                        _dropDownValue = 5;
                      }
                      if (val == "GPT-3") {
                        _dropDownValue = 6;
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: 22,
              ),
              ThemedTextField(
                "Enter Context Length",
                TextInputType.number,
                editingController: _textEditingController,
              ),
              Row(
                children: [
                  Checkbox(
                    value: this._debug,
                    onChanged: (value) {
                      setState(() {
                        this._debug = value!;
                      });
                    },
                  ),
                  Text(
                    "Debug",
                    style: ChadbotStyle.text.small,
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: this._contextprune,
                    onChanged: (value) {
                      setState(() {
                        this._contextprune = value!;
                      });
                      print("valueesss $value");
                    },
                  ),
                  Text(
                    "Context Prune",
                    style: ChadbotStyle.text.small,
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: this._contextrand,
                    onChanged: (value) {
                      setState(() {
                        this._contextrand = value!;
                      });
                      print("valueesss $value");
                    },
                  ),
                  Text(
                    "Context Rand",
                    style: ChadbotStyle.text.small,
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: this._contextoff,
                    onChanged: (value) {
                      setState(() {
                        this._contextoff = value!;
                      });
                      print("valueesss $value");
                    },
                  ),
                  Text(
                    "Context off",
                    style: ChadbotStyle.text.small,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      Dialogs.showLoadingDialog(context, _keyLoader);
                      final result = await KiwiContainer()
                          .resolve<DeleteContext>()(NoParams());
                      Navigator.of(_keyLoader.currentContext!,
                          rootNavigator: true);
                      Navigator.of(context).pop();

                      if (result.isRight()) {
                      } else {
                        print("errorrr");
                      }
                    },
                    child: Text(
                      "Delete Context",
                      style: ChadbotStyle.text.small
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _sharedPrefHelper.saveInt(
                          ChadbotConstants.model, _dropDownValue);
                      int len = 7;
                      try {
                        len = int.parse(_textEditingController.text);
                      } catch (e) {}

                      ProfileParams profileParams = ProfileParams(
                          contextlen: len,
                          contextoff: _contextoff,
                          contextprune: 0,
                          contextrand: _contextrand,
                          debug: _debug,
                          email: _sharedPrefHelper.getStringByKey(
                              ChadbotConstants.email,
                              _sharedPrefHelper.getEmail()),
                          fname: _sharedPrefHelper.getStringByKey(
                              ChadbotConstants.fname, ""),
                          lname: _sharedPrefHelper.getStringByKey(
                              ChadbotConstants.lname, ""),
                          phone: _sharedPrefHelper.getStringByKey(
                              ChadbotConstants.phone, ""),
                          chadbotGender: "",
                          chadbotname: _sharedPrefHelper.getStringByKey(
                              ChadbotConstants.chadbotName, "Kompanion"),
                          model: _dropDownValue);
                      Dialogs.showLoadingDialog(context, _keyLoader);
                      DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(_sharedPrefHelper.getExpiryTime()) * 1000);
                      if (expiryTime.isBefore(DateTime.now())) {
                        print("expirytimee before");
                        await KiwiContainer().resolve<EmailSignin>()(
                            EmailAuthParams(
                                email: _sharedPrefHelper.getEmail(),
                                password: _sharedPrefHelper.getPassword(),
                                fName: "",
                                lName: ""));
                      }
                      await _saveProfile(profileParams);
                      Navigator.of(_keyLoader.currentContext!,
                          rootNavigator: true);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.text!,
                      style: ChadbotStyle.text.small
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Submitting request....",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
