import 'package:flutter/material.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/screens/universal_variables.dart';
import 'package:spag_connect/widgets/appbar.dart';
import 'package:spag_connect/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;

  ChatScreen({this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  bool isWriting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 6,
      itemBuilder: (context, index) {
        return chatMessageItem();
      },
    );
  }

  Widget chatMessageItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: Alignment.centerRight,
        child: senderLayout(),
      ),
    );
  }

  Widget senderLayout() {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget receiverLayout() {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      FlatButton(
                        child: Icon(Icons.close),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and Tools",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                ),
                Flexible(
                    child: ListView(
                  children: <Widget>[
                    ModalTile(
                      title: "Media", 
                      subTitle: "Share Photo and Videos",
                       icon: Icons.image),
                        ModalTile(
                      title: "File", 
                      subTitle: "Share Files",
                       icon: Icons.tab),
                        ModalTile(
                      title: "Contacts", 
                      subTitle: "Share Contacts",
                       icon: Icons.contacts),
                        ModalTile(
                      title: "Location", 
                      subTitle: "Share a location",
                       icon: Icons.add_location),
                        ModalTile(
                      title: "Schedule Call", 
                      subTitle: "Arrange a Spag Call and get reminders ",
                       icon: Icons.schedule_outlined),
                        ModalTile(
                      title: "Create Poll", 
                      subTitle: "Share Polls",
                       icon: Icons.poll),
                  ],
                ))
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  gradient: UniversalVariables.fabGradient,
                  shape: BoxShape.circle),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                (value.length > 0 && value.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                  hintText: "Type a Message",
                  hintStyle: TextStyle(
                    color: UniversalVariables.greyColor,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: UniversalVariables.separatorColor,
                  suffix: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.face),
                  )),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting ? Container() : Icon(Icons.camera_alt),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 15,
                      ),
                      onPressed: () {}),
                )
              : Container()
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(widget.receiver.name),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
        IconButton(icon: Icon(Icons.phone), onPressed: () {}),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  const ModalTile(
      {@required this.title, @required this.subTitle, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: CustomTile(
          mini: false,
          leading: Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: UniversalVariables.receiverColor,
            ),
            padding: EdgeInsets.all(10),
            child: Icon(
              icon,
              color: UniversalVariables.greyColor,
              size: 38,
            ),
          ),
          subtitle: Text(
            subTitle,
            style: TextStyle(color: UniversalVariables.greyColor, fontSize: 14),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
        ));
  }
}
