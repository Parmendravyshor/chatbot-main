import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/widgets/dialogs.dart';
import 'package:chadbot/core/widgets/themed_text_field.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_single_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';

class ChadbotProfile extends StatefulWidget {
  @override
  ChadbotProfileState createState() => ChadbotProfileState();
}

class ChadbotProfileState extends State<ChadbotProfile>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController _knameController = TextEditingController();
  String _selValue = "";
  var container = KiwiContainer();
  String profileImage = KiwiContainer()
      .resolve<SharedPrefHelper>()
      .getStringByKey(
          ChadbotConstants.chadProfileImage, ChadbotConstants.defKomImage);
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  void initState() {
    _knameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SharedPrefHelper sharedPrefHelper =
        KiwiContainer().resolve<SharedPrefHelper>();

    _knameController.text = sharedPrefHelper.getStringByKey(
        ChadbotConstants.chadbotName, "Chadbot");
    _selValue =
        sharedPrefHelper.getStringByKey(ChadbotConstants.chadbotName, "");
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "Chadbot's Profile",
                    style: ChadbotStyle.text.medium
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                child: Divider(
                  color: Colors.grey[400],
                ),
              ),
              Container(
                height: 200.0,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: ExactAssetImage(profileImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.all(10.0),
                                      actions: <Widget>[
                                        IconButton(
                                          splashColor: Colors.green,
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context, null);
                                          },
                                        )
                                      ],
                                      content: Container(
                                        // Specify some width
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                        child: GridView.count(
                                            crossAxisCount: 2,
                                            childAspectRatio: 1.0,
                                            padding: const EdgeInsets.all(4.0),
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 10.0,
                                            children: <String>[
                                              'assets/profile/profile_1.png',
                                              'assets/profile/profile_2.png',
                                              'assets/profile/profile_3.png',
                                              'assets/profile/profile_4.png',
                                              'assets/profile/profile_5.png',
                                              'assets/profile/profile_6.png',
                                              'assets/profile/profile_7.png',
                                              'assets/profile/profile_8.png',
                                            ].map(
                                              (String path) {
                                                return GridTile(
                                                  child: GestureDetector(
                                                    child: Image.asset(
                                                      path,
                                                      fit: BoxFit.cover,
                                                      width: 120.0,
                                                      height: 120.0,
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(
                                                          context, path);
                                                    },
                                                  ),
                                                );
                                              },
                                            ).toList()),
                                      ),
                                    ),
                                  ).then((value) async {
                                    if (value != null) {
                                      await KiwiContainer()
                                          .resolve<SharedPrefHelper>()
                                          .saveString(
                                              ChadbotConstants.chadProfileImage,
                                              value);
                                      setState(() {
                                        profileImage = value;
                                      });
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
                            left: MediaQuery.of(context).size.width * 0.1 / 2,
                            right: MediaQuery.of(context).size.width * 0.1 / 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "",
                                    style: ChadbotStyle.text.medium,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 10.0,
                              left:
                                  MediaQuery.of(context).size.width * 0.1 / 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'My Kompanion Name',
                                    style: ChadbotStyle.text.small,
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: ThemedTextField(
                                  _selValue,
                                  TextInputType.text,
                                  enabled: !_status,
                                  editingController: _knameController,
                                ),
                              ),
                            ],
                          )),
                      !_status ? _getActionButtons() : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Save"),
                onPressed: () async {
                  await KiwiContainer().resolve<SharedPrefHelper>().saveString(
                      ChadbotConstants.chadbotName, _knameController.text);
                  Dialogs.showLoadingDialog(context, _keyLoader, "Updating..");
                  await KiwiContainer().resolve<SaveSingleField>().call(
                      SingleProfileParam("chadbotname", _knameController.text));
                  Navigator.of(_keyLoader.currentContext!, rootNavigator: true);
                  Navigator.of(context).pop();
                  setState(() {
                    _selValue = _knameController.text;
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Cancel"),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
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
