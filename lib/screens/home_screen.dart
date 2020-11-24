import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:spag_connect/enum/user_state.dart';
import 'package:spag_connect/provider/user_provider.dart';
import 'package:spag_connect/resources/auth_methods.dart';
import 'package:spag_connect/screens/callscreens/pickup/pickup_layout.dart';
import 'package:spag_connect/screens/pageviews/chat_list_screen.dart';
import 'package:spag_connect/screens/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  final AuthMethods _authMethods = AuthMethods();

  UserProvider userProvider;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.refreshUser();
      _authMethods.setUserState(
          userId: userProvider.getUser.uid, userState: UserState.Online);
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resumed state");
        break;

      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;

      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;

      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
          scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: [
            Container(
              child: ChatListScreen(),
            ),
            Center(
              child: Text(
                "Call Logs",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                "Contact Screen",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                  ),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                  ),
                  label: 'Calls',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                  ),
                  label: 'Contacts',
                ),
              ],
              currentIndex: _page,
              activeColor: UniversalVariables.lightBlueColor,
              inactiveColor: UniversalVariables.greyColor,
              onTap: navigationTapped,
            ),
          ),
        ),
      ),
    );
  }
}
