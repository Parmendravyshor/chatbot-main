import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/usecases/usecase.dart';
import 'package:chadbot/core/widgets/logo.dart';
import 'package:chadbot/feature/home/presentation/home.dart';
import 'package:chadbot/feature/login/domain/usecases/email_signin.dart';
import 'package:chadbot/feature/login/presentation/login_screen.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_registration_id.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class TryBetaScreen extends StatefulWidget {
  @override
  TryBetaWidget createState() => TryBetaWidget();
}

/// Main Widget that decides either to show Login Scree screen or Forgot password
class TryBetaWidget extends State<TryBetaScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      SharedPrefHelper sharedPrefHelper =
          KiwiContainer().resolve<SharedPrefHelper>();
      bool isloggedin = sharedPrefHelper.isLoggedin();
      if (!isloggedin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(sharedPrefHelper.getExpiryTime()) * 1000);
        if (expiryTime.isAfter(DateTime.now())) {
          await KiwiContainer().resolve<SaveRegistrationId>().call(NoParams());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          EmailSignin emailSignin = KiwiContainer().resolve<EmailSignin>();
          await emailSignin(EmailAuthParams(
              email: sharedPrefHelper.getEmail(),
              password: sharedPrefHelper.getPassword(),
              fName: "",
              lName: ""));
          await KiwiContainer().resolve<SaveRegistrationId>().call(NoParams());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      }
    });
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: ChadbotStyle.colors.cardbg,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 450,
            child: Column(
              children: [
                Container(
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(ChadbotConstants.defKomImage))),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Chadbot.ai",
                          style: ChadbotStyle.text.medium,
                        ))),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 30, child: Image.asset("assets/images/beta.png")),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
