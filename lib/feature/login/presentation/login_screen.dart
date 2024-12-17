import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/theme/style.dart';
import 'package:chadbot/core/widgets/dialog.dart';
import 'package:chadbot/core/widgets/themed_text_field.dart';
import 'package:chadbot/core/widgets/widgets.dart';
import 'package:chadbot/feature/forgotpassword/presentation/forgot_password.dart';
import 'package:chadbot/feature/home/presentation/home.dart';
import 'package:chadbot/feature/login/presentation/bloc/login_bloc.dart';
import 'package:chadbot/feature/login/presentation/bloc/login_event.dart'
    as event;
import 'package:chadbot/feature/login/presentation/bloc/login_state.dart';
import 'package:chadbot/feature/register/presentation/sign_up.dart';
import 'package:chadbot/feature/verify/presentation/bloc/verify_bloc.dart';
import 'package:chadbot/feature/verify/presentation/verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:chadbot/core/widgets/logo.dart' as logo;

import '../../bio_metric_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginWidget createState() => LoginWidget();
}

/// Main Widget that decides either to show Login Scree screen or Forgot password
class LoginWidget extends State<LoginScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  int count = 0;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KiwiContainer().resolve<LoginBloc>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Listener(
          onPointerUp: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Flexible(
                  flex: 15,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: ChadbotStyle.colors.cardbg,
                        child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            if (state is LoginSuccess) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return HomeScreen();
                                }));
                              });
                              return Container();
                            } else if (state is VerificationNeeded) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return BlocProvider(
                                    create: (context) =>
                                        KiwiContainer().resolve<VerifyBloc>(),
                                    child: Otp(
                                        _emailController.text,
                                        _passwordController.text,
                                        "",
                                        "",
                                        false),
                                  );
                                }));
                              });
                              return Container();
                            } else if (state is LoginFailure) {
                              // Future.delayed(Duration(seconds: 1), () {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return BiometricAuthScreen();
                                  ;
                                }));
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     backgroundColor: Colors.black,
                                //     content: Text(state.errorMessage,
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.w400,
                                //             fontFamily: 'Quicksand',
                                //             fontSize: 20,
                                //             color: ChadbotStyle
                                //                 .colors.textColorWhite)),
                                //   ),
                                // );
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
                                          child: logo.TopLogo(
                                              "assets/images/logo.png"))),
                                  Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Welcome to",
                                            style: ChadbotStyle.text.medium,
                                          ))),
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
                                  Container(
                                      height: 30,
                                      child: Image.asset(
                                          "assets/images/beta.png")),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ThemedTextField(
                                      "Email", TextInputType.emailAddress,
                                      onChanged: (text) {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(event.EmailChanged(text));
                                  }, editingController: _emailController),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ThemedTextField(
                                      "Password", TextInputType.visiblePassword,
                                      suffixIcon: AssetImage(
                                          "assets/images/eye-off.png"),
                                      onChanged: (text) {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(event.PasswordChanged(text));
                                  },
                                      editingController: _passwordController,
                                      password: true),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ThemedButton(
                                      text: "Login",
                                      onPressed: () {
                                        if (state
                                                is LoginFormValidationSuccess ||
                                            state
                                                is LoginFormValidationFailure) {
                                          BlocProvider.of<LoginBloc>(context)
                                              .add(event.LoginButtonTapped());
                                        }
                                      },
                                      enabled: true),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  state is LoginInProgress
                                      ? Center(
                                          child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(),
                                        ))
                                      : Container(),
                                  ResetPasswordText(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            );
                          },
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
                                  descriptions: "Please enter model Endpoint",
                                  text: "Okay",
                                );
                              });
                        }
                      },
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
                      child: RegisterText(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Text for showing at bottom of screen
/// Tapping on it should take user to reset password screen
class ResetPasswordText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: TextButton(
            onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen()),
                  )
                },
            child: Text("Forgot password?", style: ChadbotStyle.text.small)));
  }
}

/// Text for showing at bottom of screen
/// Tapping on it should take user to reset password screen
class RegisterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: TextButton(
            onPressed: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  )
                },
            child: Text("Don't have an account? Register",
                style: ChadbotStyle.text.small)));
  }
}
