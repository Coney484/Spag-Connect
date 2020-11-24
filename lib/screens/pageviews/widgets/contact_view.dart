import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spag_connect/models/contact.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/provider/user_provider.dart';
import 'package:spag_connect/resources/auth_methods.dart';
import 'package:spag_connect/resources/chat_methods.dart';
import 'package:spag_connect/screens/chatscreens/chat_screen.dart';
import 'package:spag_connect/screens/chatscreens/widgets/cached_image.dart';
import 'package:spag_connect/screens/pageviews/widgets/last_message_container.dart';
import 'package:spag_connect/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:spag_connect/screens/universal_variables.dart';
import 'package:spag_connect/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;

  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: _authMethods.getUserDetailsById(contact.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel user = snapshot.data;

            return ViewLayout(
              contact: user,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ViewLayout extends StatelessWidget {
  final UserModel contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (context) => ChatScreen(
          receiver: contact,
        ))),
      title: Text(
        contact?. name ?? "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ) ,
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(uid: contact.uid),
          ],
        ),
      ),
    );
  }
}
