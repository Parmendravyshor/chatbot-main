import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/widgets/dialog.dart';
import 'package:chadbot/core/widgets/widgets.dart';
import 'package:chadbot/feature/chat/presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kiwi/kiwi.dart';

int count = 0;
int spinnercount = 0;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            GestureDetector(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "Home",
                    style: ChadbotStyle.text.medium
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onTap: () {
                count++;
                if (count == 5) {
                  count = 0;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: "Set Model Endpoint",
                          descriptions:
                              "Please enter model Endpoint without https://",
                          text: "Okay",
                        );
                      });
                }
              },
            ),
            SizedBox(
              height: 1,
              child: Divider(
                color: Colors.grey[400],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Chadbot.ai",
                      style: ChadbotStyle.text.medium,
                    ))),
            SizedBox(
              height: 10,
            ),
            Container(height: 30, child: Image.asset("assets/images/beta.png")),
            SizedBox(
              height: 40,
            ),
          ],
        ),
        Center(
          child: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: 50),
              height: 200,
              child: Image.asset(KiwiContainer()
                  .resolve<SharedPrefHelper>()
                  .getStringByKey(ChadbotConstants.chadProfileImage,
                      ChadbotConstants.defKomImage)),
            ),
            onTap: () {},
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: CustomButton(
              text: "Start Chat",
              enabled: true,
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ChatScreen();
                  }));
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
