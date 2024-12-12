import 'package:chadbot/core/theme/chadbot_style.dart';
import 'package:chadbot/feature/debug/settings.dart';
import 'package:chadbot/feature/home/presentation/tabwidgets/home_page.dart';
import 'package:chadbot/feature/home/presentation/tabwidgets/feedback.dart'
    as f;
import 'package:chadbot/feature/home/presentation/tabwidgets/invite.dart';
import 'package:chadbot/feature/home/presentation/tabwidgets/chadbot.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../main.dart';

/// This is the stateful widget that the main application instantiates.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ChadbotProfile(),
    Invite(),
    SettingsScreen(),
    f.Feedback(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: ChadbotStyle.text.tiniest,
        backgroundColor: ChadbotStyle.colors.cardbg,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: CustomTabWidget('assets/images/home.png', true),
            icon: CustomTabWidget('assets/images/home.png', false),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: CustomTabWidget('assets/images/chadbot_tab.png', true),
            icon: CustomTabWidget('assets/images/chadbot_tab.png', false),
            label: 'Kompanion',
          ),
          BottomNavigationBarItem(
            activeIcon: CustomTabWidget('assets/images/invite.png', true),
            icon: CustomTabWidget('assets/images/invite.png', false),
            label: 'Invite',
          ),
          BottomNavigationBarItem(
            activeIcon: CustomTabWidget(
              'assets/images/feedback.png',
              true,
            ),
            icon: CustomTabWidget(
              'assets/images/feedback.png',
              false,
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            activeIcon: CustomTabWidget('assets/images/bug.png', true),
            icon: CustomTabWidget('assets/images/bug.png', false),
            label: 'Feedback',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF5332B9),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        unselectedLabelStyle: ChadbotStyle.text.tiniest,
      ),
    );
  }
}

class CustomTabWidget extends StatelessWidget {
  final String path;
  final bool active;
  final bool isIcon;
  final IconData iconData;
  CustomTabWidget(this.path, this.active,
      {this.isIcon = false, this.iconData = Icons.home});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: active ? Color(0xFF5332B9) : Color(0xFFBDC2CE),
      child: Container(
        width: 25,
        height: 25,
        child: Container(
          margin: EdgeInsets.all(4),
          child: !isIcon ? Image.asset(path) : Icon(iconData),
        ),
      ),
    );
  }
}
