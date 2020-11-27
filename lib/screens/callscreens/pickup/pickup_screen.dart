import 'package:flutter/material.dart';
import 'package:spag_connect/constants/strings.dart';
import 'package:spag_connect/models/call.dart';
import 'package:spag_connect/models/log.dart';
import 'package:spag_connect/resources/call_methods.dart';
import 'package:spag_connect/resources/local_db/repository/log_repository.dart';
import 'package:spag_connect/screens/callscreens/call_screen.dart';
import 'package:spag_connect/screens/chatscreens/widgets/cached_image.dart';
import 'package:spag_connect/utils/permission.dart';

class PickUpScreen extends StatefulWidget {
  final Call call;

  PickUpScreen({
    @required this.call,
  });

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  final CallMethods callMethods = CallMethods();

  bool isCallMissed = true;
  // initializes and adds log to db
  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    // adds the data to database
    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(widget.call);
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CallScreen(call: widget.call),
                              ),
                            )
                          : {};
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
