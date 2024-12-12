import 'dart:io';

import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/widgets/alert_manager.dart';
import 'package:chadbot/core/widgets/dialogs.dart';
import 'package:chadbot/core/widgets/themed_text_field.dart';
import 'package:chadbot/feature/home/presentation/bloc/profile_bloc.dart';
import 'package:chadbot/feature/home/presentation/bloc/profile_event.dart';
import 'package:chadbot/feature/home/presentation/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String _image = "";
  final picker = ImagePicker();
  SharedPrefHelper _prefHelper = KiwiContainer().resolve<SharedPrefHelper>();

  Future getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      _image = pickedFile.path;
      await _prefHelper.saveString(ChadbotConstants.profileImage, _image);
      setState(() {});
    } else {
      AlertManager.showErrorMessage("Failed to load image", context);
    }
  }

  @override
  void initState() {
    _fnameController = TextEditingController();
    _lnameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _image = _prefHelper.getStringByKey(ChadbotConstants.profileImage, "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _image = _prefHelper.getStringByKey(ChadbotConstants.profileImage, "");

    return BlocProvider(
      create: (context) => KiwiContainer().resolve<ProfileBloc>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Profile",
            style: ChadbotStyle.text.medium,
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          try {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true);
            Navigator.of(context).pop();
          } catch (e) {}
          _fnameController.text =
              _prefHelper.getStringByKey(ChadbotConstants.fname, "");
          _lnameController.text =
              _prefHelper.getStringByKey(ChadbotConstants.lname, "");
          _emailController.text =
              _prefHelper.getStringByKey(ChadbotConstants.email, "");
          _mobileController.text =
              _prefHelper.getStringByKey(ChadbotConstants.phone, "");
          if (state is ProfileSaveSuccess) {
            _status = true;
          }
          return Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 1,
                      child: Divider(
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 105.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child:
                                Stack(fit: StackFit.loose, children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: FileImage(File(_image)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    onTap: getImage,
                                  ),
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 70.0, right: 80.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 15.0,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.1 /
                                      2,
                                  right: MediaQuery.of(context).size.width *
                                      0.1 /
                                      2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          '',
                                          style: ChadbotStyle.text.medium,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status ? _getEditIcon() : Container(),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    left: MediaQuery.of(context).size.width *
                                        0.1 /
                                        2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'First Name',
                                          style: ChadbotStyle.text.small,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: ThemedTextField(
                                        "",
                                        TextInputType.text,
                                        enabled: !_status,
                                        editingController: _fnameController,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    left: MediaQuery.of(context).size.width *
                                        0.1 /
                                        2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Last Name',
                                          style: ChadbotStyle.text.small,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: ThemedTextField(
                                        "",
                                        TextInputType.text,
                                        enabled: !_status,
                                        editingController: _lnameController,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    left: MediaQuery.of(context).size.width *
                                        0.1 /
                                        2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Email ID',
                                          style: ChadbotStyle.text.small,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: ThemedTextField(
                                        "",
                                        TextInputType.emailAddress,
                                        enabled: false,
                                        editingController: _emailController,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    left: MediaQuery.of(context).size.width *
                                        0.1 /
                                        2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Mobile',
                                          style: ChadbotStyle.text.small,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: ThemedTextField(
                                        "",
                                        TextInputType.phone,
                                        enabled: !_status,
                                        editingController: _mobileController,
                                      ),
                                    ),
                                  ],
                                )),
                            !_status
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 25, right: 25, top: 15.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.0),
                                            child: Container(
                                                child: ElevatedButton(
                                              child: Text("Save"),
                                              onPressed: () {
                                                Dialogs.showLoadingDialog(
                                                    context,
                                                    _keyLoader,
                                                    "Updating profile..");
                                                BlocProvider.of<ProfileBloc>(
                                                        context)
                                                    .add(SubmitProfileTapped(
                                                        _fnameController.text,
                                                        _lnameController.text,
                                                        _mobileController
                                                            .text));
                                              },
                                            )),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Container(
                                                child: ElevatedButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                setState(() {
                                                  _status = true;
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                });
                                              },
                                            )),
                                          ),
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
