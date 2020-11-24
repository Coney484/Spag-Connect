import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spag_connect/models/contact.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/provider/user_provider.dart';
import 'package:spag_connect/resources/chat_methods.dart';
import 'package:spag_connect/screens/callscreens/pickup/pickup_layout.dart';
import 'package:spag_connect/screens/pageviews/widgets/contact_view.dart';
import 'package:spag_connect/screens/pageviews/widgets/new_chat_button.dart';
import 'package:spag_connect/screens/pageviews/widgets/quiet_box.dart';
import 'package:spag_connect/screens/pageviews/widgets/user_circle.dart';
import 'package:spag_connect/screens/universal_variables.dart';
import 'package:spag_connect/widgets/appbar.dart';
import 'package:spag_connect/widgets/custom_tile.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/search_screen");
            },
            ),
        IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
          scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuiteBox();
              }

              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);
                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
