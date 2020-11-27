import 'package:flutter/material.dart';
import 'package:spag_connect/screens/callscreens/pickup/pickup_layout.dart';
import 'package:spag_connect/screens/pageviews/logs/widgets/floating_column.dart';
import 'package:spag_connect/screens/pageviews/logs/widgets/log_list_container.dart';
import 'package:spag_connect/screens/pageviews/widgets/spag_connect_appbar.dart';
import 'package:spag_connect/screens/universal_variables.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
        scaffold: Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: SpagConnectAppBar(
        title: "Calls",
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search_screen');
            },
          )
        ],
      ),
      floatingActionButton: FloatingColumn(),
      body: Padding(
        padding: EdgeInsets.only(left: 15),
        child: LogListContainer(),
      ),
    ));
  }
}
