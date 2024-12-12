import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/core/theme/style.dart';
import 'package:chadbot/core/widgets/alert_manager.dart';
import 'package:chadbot/core/widgets/logo.dart';
import 'package:chadbot/core/widgets/themed_text_field.dart';
import 'package:chadbot/core/widgets/widgets.dart';
import 'package:chadbot/feature/login/presentation/login_screen.dart';
import 'package:chadbot/feature/register/presentation/bloc/register_bloc.dart';
import 'package:chadbot/feature/register/presentation/bloc/register_event.dart';
import 'package:chadbot/feature/register/presentation/bloc/register_state.dart';
import 'package:chadbot/feature/verify/presentation/bloc/verify_bloc.dart';
import 'package:chadbot/feature/verify/presentation/verify.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterWidget createState() => RegisterWidget();
}

/// Main Widget that decides either to show Login Scree screen or Forgot password
class RegisterWidget extends State<RegisterScreen> {
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cnfpasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _passwordController = TextEditingController();
    _fnameController = TextEditingController();
    _lnameController = TextEditingController();
    _emailController = TextEditingController();
    _lnameController = TextEditingController();
    _cnfpasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _cnfpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  child: BlocProvider(
                    create: (context) =>
                        KiwiContainer().resolve<RegisterBloc>(),
                    child: BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterSuccess) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return BlocProvider(
                                create: (context) =>
                                    KiwiContainer().resolve<VerifyBloc>(),
                                child: Otp(
                                  _emailController.text,
                                  _passwordController.text,
                                  _fnameController.text,
                                  _lnameController.text,
                                  true,
                                ),
                              );
                            }));
                          });
                          return Container();
                        } else if (state is RegisterFailure) {
                          Future.delayed(Duration(seconds: 1), () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(state.errorMessage,
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
                                  margin: EdgeInsets.only(top: 30),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child:
                                          TopLogo("assets/images/logo.png"))),
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
                                  child: Image.asset("assets/images/beta.png")),
                              SizedBox(
                                height: 10,
                              ),
                              ThemedTextField("First Name", TextInputType.text,
                                  onChanged: (text) {
                                BlocProvider.of<RegisterBloc>(context)
                                    .add(FNameChanged(text));
                              }, editingController: _fnameController),
                              SizedBox(
                                height: 5,
                              ),
                              ThemedTextField("Last Name", TextInputType.text,
                                  onChanged: (text) {
                                BlocProvider.of<RegisterBloc>(context)
                                    .add(LNameChanged(text));
                              }, editingController: _lnameController),
                              SizedBox(
                                height: 5,
                              ),
                              ThemedTextField(
                                  "Email", TextInputType.emailAddress,
                                  onChanged: (text) {
                                BlocProvider.of<RegisterBloc>(context)
                                    .add(EmailChanged(text));
                              }, editingController: _emailController),
                              SizedBox(
                                height: 5,
                              ),
                              ThemedTextField(
                                  "Password", TextInputType.visiblePassword,
                                  suffixIcon:
                                      AssetImage("assets/images/eye-off.png"),
                                  onChanged: (text) {
                                BlocProvider.of<RegisterBloc>(context)
                                    .add(PasswordChanged(text));
                              },
                                  editingController: _passwordController,
                                  password: true),
                              SizedBox(
                                height: 5,
                              ),
                              ThemedTextField("Confirm Password",
                                  TextInputType.visiblePassword,
                                  suffixIcon:
                                      AssetImage("assets/images/eye-off.png"),
                                  onChanged: (text) {},
                                  editingController: _cnfpasswordController,
                                  password: true),
                              SizedBox(
                                height: 5,
                              ),
                              ThemedButton(
                                  text: "Register",
                                  onPressed: () {
                                    String fname = _fnameController.text;
                                    String lname = _lnameController.text;
                                    String email = _emailController.text;
                                    String password = _passwordController.text;
                                    String cnfpassword =
                                        _cnfpasswordController.text;

                                    if (fname.isEmpty) {
                                      AlertManager.showErrorMessage(
                                          "Please enter first name", context);
                                    } else if (lname.isEmpty) {
                                      AlertManager.showErrorMessage(
                                          "Please enter last name", context);
                                    } else if (!EmailValidator.validate(
                                        email)) {
                                      AlertManager.showErrorMessage(
                                          "Please enter valid email", context);
                                    } else if (password.length < 6) {
                                      AlertManager.showErrorMessage(
                                          "Password must be 6 characters long",
                                          context);
                                    } else if (password != cnfpassword) {
                                      AlertManager.showErrorMessage(
                                          "Password do not match", context);
                                    } else {
                                      BlocProvider.of<RegisterBloc>(context)
                                          .add(RegisterButtonTapped());
                                    }
                                  },
                                  enabled: true),
                              SizedBox(
                                height: 20,
                              ),
                              state is RegisterInProgress
                                  ? Center(
                                      child: Container(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(),
                                    ))
                                  : Container(),
                              Container(
                                height: 50,
                                decoration: new BoxDecoration(
                                    color: ChadbotStyle.colors.bottomBg),
                                child: Center(
                                  child: GoToSignInText(),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
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
