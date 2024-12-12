import 'package:chadbot/core/data/datasources/database.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:chadbot/core/widgets/alert_manager.dart';
import 'package:chadbot/feature/debug/debug_menu.dart';
import 'package:chadbot/feature/home/presentation/tabwidgets/user_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/delete_cognito.dart';
import 'package:chadbot/feature/verify/domain/usecases/delete_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    //return buildSettingsList();
    return Column(
      children: [
        Container(
          height: 50,
          child: Center(
            child: Text(
              "Settings",
              style: ChadbotStyle.text.medium
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        CustomListItem(
          Icons.person,
          "Profile",
          callback: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return UserProfile();
            }));
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 50),
          child: SizedBox(
            height: 1,
            child: Divider(
              color: Colors.grey[400],
            ),
          ),
        ),
        CustomListItem(
          Icons.bug_report,
          "Debug Menu",
          callback: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return DebugMenu();
            }));
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 50),
          child: SizedBox(
            height: 1,
            child: Divider(
              color: Colors.grey[400],
            ),
          ),
        ),
        CustomListItem(
          Icons.logout,
          "Logout",
          callback: () async {
            Database db = await DBProvider.db.database;
            await db.delete("message");
            await KiwiContainer().resolve<SharedPreferences>().clear();
            Phoenix.rebirth(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 50),
          child: SizedBox(
            height: 1,
            child: Divider(
              color: Colors.grey[400],
            ),
          ),
        ),
        CustomListItem(
          Icons.delete,
          "Delete Profile",
          callback: () async {
            Dialogs.showLoadingDialog(context, _keyLoader, "Deleting profile");

            var response =
                await KiwiContainer().resolve<DeleteProfile>()(NoParams());
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (response.isRight()) {
              final dres = await KiwiContainer()
                  .resolve<DeleteCognitoAccount>()(NoParams());
              if (dres.isRight()) {
                Database db = await DBProvider.db.database;
                await db.delete("message");
                await KiwiContainer().resolve<SharedPreferences>().clear();
                Phoenix.rebirth(context);
              } else {
                AlertManager.showErrorMessage(
                    "Some error occurred. Please try again", context);
              }
            } else {
              AlertManager.showErrorMessage(
                  "Some error occurred. Please try again", context);
            }
          },
        ),
      ],
    );
  }
}

class CustomListItem extends StatelessWidget {
  final IconData icons;
  final String text;
  final VoidCallback callback;
  CustomListItem(this.icons, this.text, {required this.callback});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Icon(icons),
              ),
              Text(
                text,
                style: TextStyle(color: Color(0xFF777777), fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      onTap: callback,
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String message) async {
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
                          message,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
