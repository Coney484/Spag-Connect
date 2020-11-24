import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/provider/user_provider.dart';
import 'package:spag_connect/resources/auth_methods.dart';
import 'package:spag_connect/screens/chatscreens/widgets/cached_image.dart';
import 'package:spag_connect/screens/login_screen.dart';
import 'package:spag_connect/screens/pageviews/widgets/shimmering_logo.dart';
import 'package:spag_connect/widgets/appbar.dart';


class UserDetailsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    signOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();

      if (isLoggedOut) {
        // navigate the user to login screnn;
        // such that he is not able to back by tapping the back button

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: ShimmeringLogo(),
            actions: <Widget>[
              FlatButton(
                onPressed: () => signOut(),
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final UserModel user = userProvider.getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user.email,
                style: TextStyle(fontSize: 14, color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}
