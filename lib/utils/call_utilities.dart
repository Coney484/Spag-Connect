import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spag_connect/constants/strings.dart';
import 'package:spag_connect/models/call.dart';
import 'package:spag_connect/models/log.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/resources/call_methods.dart';
import 'package:spag_connect/resources/local_db/repository/log_repository.dart';
import 'package:spag_connect/screens/callscreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserModel from, UserModel to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );
    Log log = Log(
        callerName: from.name,
        callerPic: from.profilePhoto,
        callStatus: CALL_STATUS_DIALEED,
        receiverName: to.name,
        receiverPic: to.profilePhoto,
        timestamp: DateTime.now().toString());

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      //adds call logs to local db
      LogRepository.addLogs(log);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CallScreen(call: call)));
    }
  }
}
