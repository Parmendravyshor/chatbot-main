import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:chadbot/core/widgets/alert_manager.dart';
import 'package:chadbot/core/widgets/dialogs.dart';
import 'package:chadbot/core/widgets/themed_text_field.dart';
import 'package:chadbot/feature/login/domain/usecases/email_signin.dart';
import 'package:chadbot/feature/verify/domain/usecases/delete_context.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_debug.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class DebugMenu extends StatefulWidget {
  @override
  DebugMenuState createState() {
    return new DebugMenuState();
  }
}

class DebugMenuState extends State<DebugMenu> {
  bool _debug = false;
  bool _contextoff = false;
  bool _contextrand = false;

  TextEditingController _controller = TextEditingController();
  int _dropDownValue = 0;
  String _selValue = "DialoGPT-Large";
  SharedPrefHelper _sharedPrefHelper =
      KiwiContainer().resolve<SharedPrefHelper>();
  TextEditingController _contextLenController = TextEditingController();
  TextEditingController _tempController = TextEditingController();
  TextEditingController _toppController = TextEditingController();
  TextEditingController _topkController = TextEditingController();
  TextEditingController _repetitionController = TextEditingController();

  TextEditingController _userPersonaController = TextEditingController();
  TextEditingController _pokeDelayController = TextEditingController();
  TextEditingController _pokeTopController = TextEditingController();
  TextEditingController _memoriesController = TextEditingController();
  TextEditingController _lastseenController = TextEditingController();
  TextEditingController _lastpokedController = TextEditingController();
  TextEditingController _contextPruneController = TextEditingController();

  SaveDebug _saveProfile = KiwiContainer().resolve<SaveDebug>();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _tempController = TextEditingController();
    _toppController = TextEditingController();
    _topkController = TextEditingController();
    _repetitionController = TextEditingController();
    _contextLenController = TextEditingController();

    _userPersonaController = TextEditingController();
    _pokeDelayController = TextEditingController();
    _pokeTopController = TextEditingController();
    _memoriesController = TextEditingController();
    _lastseenController = TextEditingController();
    _lastpokedController = TextEditingController();
    _contextPruneController = TextEditingController();

    _dropDownValue = _sharedPrefHelper.getIntByKey(ChadbotConstants.model, 0);

    _tempController.text =
        "${_sharedPrefHelper.getDouble(ChadbotConstants.temp, 0.9)}";
    _toppController.text =
        "${_sharedPrefHelper.getDouble(ChadbotConstants.topp, 0.9)}";
    _repetitionController.text =
        "${_sharedPrefHelper.getDouble(ChadbotConstants.repetition, 1.3)}";
    _topkController.text =
        "${_sharedPrefHelper.getIntByKey(ChadbotConstants.topk, 10)}";
    _contextLenController.text =
        "${_sharedPrefHelper.getIntByKey(ChadbotConstants.contextlen, 7)}";

    _userPersonaController.text =
        "${_sharedPrefHelper.getIntByKey(ChadbotConstants.userpersona, 10)}";
    _pokeDelayController.text =
        "${_sharedPrefHelper.getIntByKey(ChadbotConstants.pokedelay, 30)}";
    _pokeTopController.text =
        "${_sharedPrefHelper.getIntByKey(ChadbotConstants.poketop, 2)}";
    _memoriesController.text =
        "${_sharedPrefHelper.getIntByKey(ChadbotConstants.memories, 0)}";
    _lastseenController.text =
        "${_sharedPrefHelper.getStringByKey(ChadbotConstants.lastseen, "")}";
    _lastpokedController.text =
        "${_sharedPrefHelper.getStringByKey(ChadbotConstants.lastpoked, "")}";
    _contextPruneController.text =
        "${_sharedPrefHelper.getIntByKey(ChadbotConstants.contextprune, 0)}";

    _debug = _sharedPrefHelper.getBoolByKey(ChadbotConstants.debug, false);
    _contextoff =
        _sharedPrefHelper.getBoolByKey(ChadbotConstants.contextoff, false);
    _contextrand =
        _sharedPrefHelper.getBoolByKey(ChadbotConstants.contextrand, false);
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
    _contextLenController.dispose();
    _tempController.dispose();
    _toppController.dispose();
    _topkController.dispose();
    _repetitionController.dispose();
    _contextPruneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Debug Menu",
          style: ChadbotStyle.text.medium,
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () async {
                  saveProfileUser();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        size: 30.0,
                      ),
                      onTap: () {
                        deleteContext();
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.done,
                      size: 30.0,
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          margin: EdgeInsets.only(top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: DropdownButton(
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
              ),
              SizedBox(
                height: 22,
              ),
              _textWidget("Context Length"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter Context Length",
                TextInputType.number,
                editingController: _contextLenController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("Temp"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter temp",
                TextInputType.numberWithOptions(decimal: true),
                editingController: _tempController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("TopP"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter TopP",
                TextInputType.numberWithOptions(decimal: true),
                editingController: _toppController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("TopK"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter topk",
                TextInputType.number,
                editingController: _topkController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("Repetition"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter repetition",
                TextInputType.numberWithOptions(decimal: true),
                editingController: _repetitionController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("Userpersona"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter Userpersona",
                TextInputType.number,
                editingController: _userPersonaController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("Poke Delay"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter Poke Delay",
                TextInputType.number,
                editingController: _pokeDelayController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("Poke Top"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter Poke Top",
                TextInputType.number,
                editingController: _pokeTopController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("Memories"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter Memories",
                TextInputType.number,
                editingController: _memoriesController,
              ),
              SizedBox(
                height: 10,
              ),
              _textWidget("Last Seen"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter Last Seen",
                TextInputType.text,
                editingController: _lastseenController,
              ),
              _textWidget("Last Poked"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter Last Poked",
                TextInputType.text,
                editingController: _lastpokedController,
              ),
              _textWidget("Context Prune"),
              SizedBox(
                height: 5,
              ),
              ThemedTextField(
                "Enter Context Prune",
                TextInputType.number,
                editingController: _contextPruneController,
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveProfileUser() async {
    await _sharedPrefHelper.saveInt(ChadbotConstants.model, _dropDownValue);
    int len = 7;
    try {
      len = int.parse(_contextLenController.text);
    } catch (e) {}

    double temp = _sharedPrefHelper.getDouble(ChadbotConstants.temp, 0.9);
    try {
      temp = double.parse(_tempController.text);
    } catch (e) {}

    double topp = _sharedPrefHelper.getDouble(ChadbotConstants.topp, 0.9);
    try {
      topp = double.parse(_toppController.text);
    } catch (e) {}

    int topk = _sharedPrefHelper.getIntByKey(ChadbotConstants.topk, 10);
    try {
      len = int.parse(_topkController.text);
    } catch (e) {}

    double repetition =
        _sharedPrefHelper.getDouble(ChadbotConstants.repetition, 1.3);
    try {
      repetition = double.parse(_repetitionController.text);
    } catch (e) {}

    int userpersona =
        _sharedPrefHelper.getIntByKey(ChadbotConstants.userpersona, 30);
    try {
      userpersona = int.parse(_userPersonaController.text);
    } catch (e) {}

    int memories = _sharedPrefHelper.getIntByKey(ChadbotConstants.memories, 0);
    try {
      memories = int.parse(_memoriesController.text);
    } catch (e) {}

    int pokedelay =
        _sharedPrefHelper.getIntByKey(ChadbotConstants.pokedelay, 30);
    try {
      pokedelay = int.parse(_pokeDelayController.text);
    } catch (e) {}

    int poketop = _sharedPrefHelper.getIntByKey(ChadbotConstants.poketop, 2);
    try {
      poketop = int.parse(_pokeTopController.text);
    } catch (e) {}

    int cntextPrune =
        _sharedPrefHelper.getIntByKey(ChadbotConstants.contextprune, 2);
    try {
      cntextPrune = int.parse(_contextPruneController.text);
    } catch (e) {}

    String lastseen =
        _sharedPrefHelper.getStringByKey(ChadbotConstants.lastseen, "");
    try {
      lastseen = _lastseenController.text;
    } catch (e) {}

    String lastpoked =
        _sharedPrefHelper.getStringByKey(ChadbotConstants.lastpoked, "");
    try {
      lastpoked = _lastpokedController.text;
    } catch (e) {}

    ProfileParams profileParams = ProfileParams(
      contextlen: len,
      contextoff: _contextoff,
      contextprune: cntextPrune,
      contextrand: _contextrand,
      debug: _debug,
      email: _sharedPrefHelper.getStringByKey(
          ChadbotConstants.email, _sharedPrefHelper.getEmail()),
      fname: _sharedPrefHelper.getStringByKey(ChadbotConstants.fname, ""),
      lname: _sharedPrefHelper.getStringByKey(ChadbotConstants.lname, ""),
      phone: _sharedPrefHelper.getStringByKey(ChadbotConstants.phone, ""),
      chadbotGender: "",
      chadbotname: _sharedPrefHelper.getStringByKey(
          ChadbotConstants.chadbotName, "Chadbot"),
      model: _dropDownValue,
      temp: temp,
      topp: topp,
      topk: topk,
      repetition: repetition,
      pokeDelay: pokedelay,
      pokeTop: poketop,
      memories: memories,
      userpersona: userpersona,
      lastpoked: lastpoked,
      lastseen: lastseen,
    );
    //Dialogs.showLoadingDialog(context, _keyLoader, "Submitting request..");
    DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(_sharedPrefHelper.getExpiryTime()) * 1000);
    if (expiryTime.isBefore(DateTime.now())) {
      print("expirytimee before");
      await KiwiContainer().resolve<EmailSignin>()(EmailAuthParams(
          email: _sharedPrefHelper.getEmail(),
          password: _sharedPrefHelper.getPassword(),
          fName: "",
          lName: ""));
    }
    final result = await _saveProfile(profileParams);
    if (result.isRight()) {
      AlertManager.showSuccessMessage(
          "Debug menu updated successfully.", context);
    } else {
      AlertManager.showErrorMessage(
          "Some error occurred. Please try again.", context);
    }
  }

  Future<void> deleteContext() async {
    final result = await KiwiContainer().resolve<DeleteContext>()(NoParams());
    if (result.isRight()) {
      AlertManager.showSuccessMessage("Context deleted successfully.", context);
    } else {
      AlertManager.showErrorMessage(
          "Some error occurred. Please try again.", context);
    }
  }
}

_textWidget(String s) {
  return Padding(
    padding: EdgeInsets.only(left: 20),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        s,
        style: ChadbotStyle.text.small,
      ),
    ),
  );
}
