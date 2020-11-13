import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spag_connect/screens/pageviews/chat_list_screen.dart';
import 'package:spag_connect/screens/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
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
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        children: [
          Container(child: ChatListScreen(),),
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
    );
  }
}
