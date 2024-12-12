import 'package:chadbot/core/theme/chadbot_style.dart';

import 'package:chadbot/core/widgets/logo.dart';
import 'package:chadbot/core/widgets/themed_text_field.dart';
import 'package:chadbot/core/widgets/widgets.dart';
import 'package:chadbot/feature/home/presentation/home.dart';
import 'package:chadbot/feature/login/presentation/login_screen.dart';
import 'package:chadbot/feature/verify/presentation/bloc/verify_bloc.dart';
import 'package:chadbot/feature/verify/presentation/bloc/verify_event.dart';
import 'package:chadbot/feature/verify/presentation/bloc/verify_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

class Otp extends StatefulWidget {
  final String email;
  final String password;
  final String fname;
  final String lname;
  final bool isRegister;
  Otp(
    this.email,
    this.password,
    this.fname,
    this.lname,
    this.isRegister,
  );
  @override
  OtpWidget createState() =>
      OtpWidget(email, password, fname, lname, isRegister);
}

/// Main Widget that decides either to show Login Scree screen or Forgot password
class OtpWidget extends State<Otp> {
  TextEditingController _otpController = TextEditingController();
  final String email;
  final String password;
  final String fname;
  final String lname;
  final bool isRegister;
  OtpWidget(
    this.email,
    this.password,
    this.fname,
    this.lname,
    this.isRegister,
  );

  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KiwiContainer().resolve<VerifyBloc>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                flex: 15,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: ChadbotStyle.colors.cardbg,
                    child: BlocBuilder<VerifyBloc, VerifyState>(
                      builder: (context, state) {
                        if (state is VerifyOtpSuccess) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return HomeScreen();
                            }));
                          });
                          return Container();
                        }
                        if (state is ResendOtpSuccess) {
                          Future.delayed(Duration(seconds: 1), () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Text("Otp resent successfully",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Quicksand',
                                        fontSize: 20,
                                        color: ChadbotStyle
                                            .colors.textColorWhite)),
                              ),
                            );
                          });
                        }
                        if (state is ResendOtpFailure) {
                          Future.delayed(Duration(seconds: 1), () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(state.message,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Quicksand',
                                        fontSize: 20,
                                        color: ChadbotStyle
                                            .colors.textColorWhite)),
                              ),
                            );
                          });
                        }
                        if (state is VerifyOtpFailure) {
                          Future.delayed(Duration(seconds: 1), () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(state.message,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Quicksand',
                                        fontSize: 20,
                                        color: ChadbotStyle
                                            .colors.textColorWhite)),
                              ),
                            );
                          });
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 80),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child:
                                          TopLogo("assets/images/logo.png"))),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Please enter the OTP sent on your registered Email ID",
                                        style: ChadbotStyle.text.medium,
                                        textAlign: TextAlign.center,
                                      ))),
                              SizedBox(
                                height: 30,
                              ),
                              ThemedTextField(
                                  "Enter 6 digit otp code", TextInputType.phone,
                                  onChanged: (text) {},
                                  editingController: _otpController),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                child: Container(
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Resend verification code",
                                          style: ChadbotStyle.text.medium,
                                          textAlign: TextAlign.center,
                                        ))),
                                onTap: () {
                                  BlocProvider.of<VerifyBloc>(context)
                                      .add(ResendButtonTapped(email));
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ThemedButton(
                                  text: "Verify",
                                  onPressed: () {
                                    if (_otpController.text.length < 6) return;
                                    BlocProvider.of<VerifyBloc>(context).add(
                                        CodeEntered(
                                            _otpController.text,
                                            email,
                                            password,
                                            fname,
                                            lname,
                                            isRegister));
                                  },
                                  enabled: true),
                              SizedBox(
                                height: 20,
                              ),
                              state is VerifyOtpInProgress ||
                                      state is ResendOtpInProgress
                                  ? Center(
                                      child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(),
                                    ))
                                  : Container(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: new BoxDecoration(
                      border: Border.all(
                        color: ChadbotStyle.colors.borderColor,
                        width: 1,
                      ),
                      color: ChadbotStyle.colors.bottomBg),
                  child: Center(
                    child: GoToSignInText(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Text for showing at bottom of screen
/// Tapping on it should take user to reset password screen
class GoToSignInText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TextButton(
        onPressed: () => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          )
        },
        child: Text("Already have an account? Log in",
            style: ChadbotStyle.text.small),
      ),
    );
  }
}
