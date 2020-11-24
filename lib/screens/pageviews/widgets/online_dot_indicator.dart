import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spag_connect/enum/user_state.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/resources/auth_methods.dart';
import 'package:spag_connect/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({@required this.uid});

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.deepOrange;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _authMethods.getUserStream(uid: uid),
      builder: (context, snapshot) {
        UserModel user;

        if (snapshot.hasData && snapshot.data.data != null) {
          user = UserModel.fromMap(snapshot.data.data);
        }

        return Container(
          height: 10,
          width: 10,
          margin: EdgeInsets.only(right: 8, top: 8),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: getColor(user?.state)),
        );
      },
    );
  }
}
