import 'package:flutter/material.dart';
import 'package:spag_connect/constants/strings.dart';
import 'package:spag_connect/models/log.dart';
import 'package:spag_connect/resources/local_db/repository/log_repository.dart';
import 'package:spag_connect/screens/chatscreens/widgets/cached_image.dart';
import 'package:spag_connect/utils/utilities.dart';
import 'package:spag_connect/widgets/custom_tile.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALEED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;
      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: LogRepository.getLogs(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<dynamic> logList = snapshot.data;
            if (logList.isNotEmpty) {
              return ListView.builder(
                itemCount: logList.length,
                itemBuilder: (context, index) {
                  Log _log = logList[index];
                  bool hasDialled = _log.callStatus == CALL_STATUS_DIALEED;
                  return CustomTile(
                    leading: CachedImage(
                      hasDialled ? _log.receiverPic : _log.callerPic,
                      isRound: true,
                      radius: 45,
                    ),
                    mini: false,
                    title: Text(
                      hasDialled ? _log.receiverName : _log.callerName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    icon: getIcon(_log.callStatus),
                    subtitle: Text(
                      Utils.formatDateString(_log.timestamp),
                      style: TextStyle(fontSize: 13),
                    ),
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Delete this log?"),
                        content: Text("Are you sure to delete this log?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              Navigator.maybePop(context);
                              await LogRepository.deleteLogs(index);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: ()  {
                              Navigator.maybePop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        });
  }
}
