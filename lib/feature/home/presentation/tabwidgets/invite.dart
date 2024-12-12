import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Invite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "Invite",
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
              height: 30,
            ),
            Container(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Welcome to Chadbot.ai",
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
          child: Container(
            margin: EdgeInsets.only(top: 50, left: 30, right: 30),
            height: 200,
            child: Text(
              "Invite your friends to join Chadbot.ai!",
              style: ChadbotStyle.text.medium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: CustomButton(
              text: "Send Invite",
              enabled: true,
              onPressed: () async {
                print("inviteeeeee");
                await Share.share(
                    'Hey! Come check out the Chadbot.ai app. It lets your create talk to your very own virtual AI friend! You can download it for iOS here and for Android here!',
                    subject: 'Kompanion');
              },
            ),
          ),
        )
      ],
    );
  }
}
