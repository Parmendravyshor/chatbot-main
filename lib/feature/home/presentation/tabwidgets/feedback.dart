import 'dart:convert';
import 'dart:io';

import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  String email = "";
  String description = "";
  String bugtype = "";
  String subject = "";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                "Feedback",
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 13),
            child: Text(
              "Leave us a message, and we'll get in contact with you as soon as possible. ",
              style: ChadbotStyle.text.medium.copyWith(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: DropdownButton(
              hint: bugtype.isEmpty
                  ? Text(
                      'Select type',
                      style: ChadbotStyle.text.small,
                    )
                  : Text(
                      bugtype,
                      style: ChadbotStyle.text.small,
                    ),
              isExpanded: true,
              iconSize: 30.0,
              style: TextStyle(color: Colors.blue),
              items: [
                'Bug Report',
                'Feature Request',
                'Contact Us?',
              ].map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      style: ChadbotStyle.text.small,
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(
                  () {
                    bugtype = val.toString();
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: TextField(
              onChanged: (val) {
                email = val;
              },
              textAlign: TextAlign.start,
              controller: t1,
              maxLines: null,
              style: ChadbotStyle.text.small,
              decoration: InputDecoration(
                hintText: 'Email Address',
                hintStyle: ChadbotStyle.text.small,
                border: ChadbotStyle.defaultBorder,
                enabledBorder: ChadbotStyle.defaultBorder,
                focusedBorder: ChadbotStyle.defaultBorder,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: TextField(
              onChanged: (val) {
                subject = val;
              },
              textAlign: TextAlign.start,
              controller: t3,
              maxLines: null,
              style: ChadbotStyle.text.small,
              decoration: InputDecoration(
                hintText: 'Subject',
                hintStyle: ChadbotStyle.text.small,
                border: ChadbotStyle.defaultBorder,
                enabledBorder: ChadbotStyle.defaultBorder,
                focusedBorder: ChadbotStyle.defaultBorder,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: TextField(
              onChanged: (val) {
                description = val;
              },
              textAlign: TextAlign.start,
              controller: t2,
              maxLines: null,
              style: ChadbotStyle.text.small,
              decoration: InputDecoration(
                hintText: 'Your message',
                hintStyle: ChadbotStyle.text.small,
                border: ChadbotStyle.defaultBorder,
                enabledBorder: ChadbotStyle.defaultBorder,
                focusedBorder: ChadbotStyle.defaultBorder,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          FractionallySizedBox(
              widthFactor: 0.9,
              child: Card(
                color: ChadbotStyle.colors.enableButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() async {
                      if (EmailValidator.validate(email) &&
                          description.isNotEmpty &&
                          bugtype.isNotEmpty &&
                          subject.isNotEmpty) {
                        Dialogs.showLoadingDialog(context, _keyLoader);
                        var jsonResponse =
                            await getData(bugtype, email, subject, description);
                        Navigator.of(_keyLoader.currentContext!,
                                rootNavigator: true)
                            .pop();
                        await _showMyDialog(
                            convert.jsonDecode(jsonResponse.body)['message']);
                        t1.clear();
                        t2.clear();
                        t3.clear();
                        resetVariables();
                      } else {
                        await _showMyDialog("Please fill all information");
                      }
                    });
                  },
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                            child: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Center(
                            child: Text(
                          "Send",
                          textAlign: TextAlign.center,
                          style: ChadbotStyle.text.medium.copyWith(
                              color: ChadbotStyle.colors.whiteColor,
                              fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Future<http.Response> getData(
      String label, String email, String subject, String decription) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
    return http.post(
      Uri.https(ChadbotConstants.githubdomain, ChadbotConstants.githubendpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'label': label,
        'email': email,
        'subject': subject,
        'issue': "$description ${deviceData.toString()}",
      }),
    );
  }

  Future<void> _showMyDialog(message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Thanks',
            style: ChadbotStyle.text.medium,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message != null ? message : "Request submitted successfully",
                  style: ChadbotStyle.text.medium,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Ok',
                style: ChadbotStyle.text.medium,
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetVariables() {
    email = "";
    description = "";
    subject = "";
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
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
