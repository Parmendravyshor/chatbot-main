import 'dart:async';
import 'dart:io';
import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/feature/chat/domain/entity/message.dart';
import 'package:chadbot/feature/chat/presentation/bloc/chat_bloc.dart';
import 'package:chadbot/feature/chat/presentation/bloc/chat_event.dart';
import 'package:chadbot/feature/chat/presentation/bloc/chat_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  bool isAppodealInitialized = true;
  bool isfirst = true;
  final TextEditingController _textEditingController =
      new TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  final _controller = ScrollController();

  final container = KiwiContainer();
  List<Message> messageList = [];
  String _image = "";
  SharedPrefHelper _prefHelper = KiwiContainer().resolve<SharedPrefHelper>();

  @override
  void initState() {
    super.initState();
    _image = _prefHelper.getStringByKey(ChadbotConstants.profileImage, "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => container.resolve<ChatBloc>(),
      child: Screenshot(
          controller: screenshotController,
          child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: new Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  KiwiContainer()
                      .resolve<SharedPrefHelper>()
                      .getStringByKey(ChadbotConstants.chadbotName, "Chadbot"),
                  style: ChadbotStyle.text.medium,
                ),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                          onTap: () async {
                            //from path_provide package
                            final directory =
                                await getApplicationDocumentsDirectory();

                            String fName =
                                '${DateTime.now().microsecondsSinceEpoch}.png';
                            String path = directory.path;

                            final savePath =
                                await screenshotController.captureAndSave(
                                    path, //set path where screenshot will be saved
                                    fileName: fName,
                                    pixelRatio: MediaQuery.of(context)
                                        .devicePixelRatio);
                            List<String> paths = [];
                            paths.add(savePath!);
                            await Share.shareFiles(paths);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share,
                                size: 20.0,
                              ),
                              Text(
                                "Share",
                                style: ChadbotStyle.text.small,
                              ),
                            ],
                          ))),
                ],
                centerTitle: true,
                backgroundColor: ChadbotStyle.colors.cardbg),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 0.5,
                    child: Divider(
                      color: Colors.grey[350],
                    ),
                  ),
                  Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    flex: 15,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {
                          if (state is ChatSendInitial) {
                            BlocProvider.of<ChatBloc>(context)
                                .add(ChatOpened());
                          }
                          if (state is ChatSendInProgress) {
                            if (messageList.length == 0) {
                              messageList = state.messageList;
                            }
                            final typeMessage = Message("typing", 3);
                            messageList.add(typeMessage);
                          }
                          if (state is ChatSendSuccess) {
                            messageList.removeWhere(
                                (element) => element.typeOfMsg == 3);
                            messageList = state.messageList;
                          }

                          if (messageList.length > 2) {
                            messageList.removeWhere(
                                (element) => element.typeOfMsg == 4);
                            final sentMessage = Message("", 4);
                            messageList.add(sentMessage);
                          }

                          Future.delayed(Duration(milliseconds: 200), () {
                            if (isfirst) {
                              isfirst = false;
                              _controller
                                  .jumpTo(_controller.position.maxScrollExtent);
                            } else {
                              _controller.animateTo(
                                  _controller.position.maxScrollExtent,
                                  duration: Duration(seconds: 2),
                                  curve: Curves.fastOutSlowIn);
                            }
                          });

                          return ListView.builder(
                            controller: _controller,
                            itemCount: messageList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              Message message = messageList.elementAt(index);
                              if (message.typeOfMsg == 1) {
                                return Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.70),
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              212, 234, 244, 1.0),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                        ),
                                        child: Text(
                                          message.text,
                                          style: ChadbotStyle.text.small,
                                        ),
                                      ),
                                      AvatarImage(
                                          KiwiContainer()
                                              .resolve<SharedPrefHelper>()
                                              .getStringByKey(
                                                  ChadbotConstants
                                                      .chadProfileImage,
                                                  ChadbotConstants.defKomImage),
                                          false),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                );
                              } else if (message.typeOfMsg == 2) {
                                return Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      _image.isEmpty
                                          ? AvatarImage(
                                              "assets/images/chat_avatar.png",
                                              false)
                                          : AvatarImage(_image, true),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.70),
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(left: 20),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              225, 255, 199, 1.0),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                        ),
                                        child: Text(message.text,
                                            style: ChadbotStyle.text.small),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (message.typeOfMsg == 3) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    width: 50,
                                    height: 50,
                                    child: JumpingDotsProgressIndicator(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: 55,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration:
                          new BoxDecoration(color: Theme.of(context).cardColor),
                      child: _buildTextComposer(),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _onButtonPressed,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _onButtonPressed,
    );
  }

  Widget _buildTextComposer() {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textEditingController,
                style: ChadbotStyle.text.small,
                onChanged: (String messageText) {},
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {
                  if (_textEditingController.text.isEmpty) return;
                  BlocProvider.of<ChatBloc>(context).isFromException = false;
                  BlocProvider.of<ChatBloc>(context)
                      .add(ChatMessageSent(_textEditingController.text));
                  _textEditingController.clear();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void _onButtonPressed() {
    _textEditingController.clear();
  }
}

class AvatarImage extends StatelessWidget {
  final String imagepath;
  final bool isfile;
  AvatarImage(this.imagepath, this.isfile);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: FileImage(File(imagepath)),
            fit: BoxFit.cover,
          ),
        ));
  }
}

class JumpingDot extends AnimatedWidget {
  JumpingDot({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Listenable animation = listenable;
    return Container(
      height: 40,
      child: Text('.'),
    );
  }
}
