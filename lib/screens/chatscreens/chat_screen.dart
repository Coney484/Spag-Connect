import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:spag_connect/constants/strings.dart';
import 'package:spag_connect/enum/view_state.dart';
import 'package:spag_connect/models/message.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/provider/image_upload_provider.dart';
import 'package:spag_connect/resources/auth_methods.dart';
import 'package:spag_connect/resources/chat_methods.dart';
import 'package:spag_connect/resources/storage_methods.dart';
import 'package:spag_connect/screens/callscreens/pickup/pickup_layout.dart';
import 'package:spag_connect/screens/chatscreens/widgets/cached_image.dart';
import 'package:spag_connect/screens/universal_variables.dart';
import 'package:spag_connect/utils/call_utilities.dart';
import 'package:spag_connect/utils/permission.dart';
import 'package:spag_connect/utils/utilities.dart';
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
  ScrollController _listScrollController = ScrollController();
  // FirebaseRepository _repository = FirebaseRepository();

  final StorageMethods _storageMethods = StorageMethods();
  final ChatMethods _chatMethods = ChatMethods();
  final AuthMethods _authMethods = AuthMethods();
  ImageUploadProvider _imageUploadProvider;

  UserModel sender;

  String _currentUserId;

  FocusNode textFieldFocus = FocusNode();

  bool isWriting = false;

  bool showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = UserModel(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  showKeyBoard() => textFieldFocus.requestFocus();

  hideKeyBoard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15),
                  child: CircularProgressIndicator())
              : Container(),
          chatControls(),
          showEmojiPicker ? Container(child: emojiContainer()) : Container(),
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blackColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
    // return emojiPicker;
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(MESSAGES_COLLECTION)
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   _listScrollController.animateTo(
        //     _listScrollController.position.minScrollExtent,
        //     duration: Duration(milliseconds: 250),
        //     curve: Curves.easeInOut,
        //   );
        // });

        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            reverse: true,
            controller: _listScrollController,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data.documents[index]);
            });
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
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
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return message.type != MESSAGE_TYPE_IMAGE
        ? Text(
            message.message,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          )
        : message.photoUrl != null
            ? CachedImage(
                message.photoUrl,
                height: 250,
                width: 150,
                radius: 10,
              )
            : Text("Url was Null");
  }

  void pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _storageMethods.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }

  Widget receiverLayout(Message message) {
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
        child: getMessage(message),
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
                        icon: Icons.image,
                        onTap: () => pickImage(source: ImageSource.gallery)),
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
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  onTap: () => hideEmojiContainer(),
                  focusNode: textFieldFocus,
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
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      //keyboard is visible
                      hideKeyBoard();
                      showEmojiContainer();
                    } else {
                      //keyboard is hidden
                      showKeyBoard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.face),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(source: ImageSource.camera),
                  child: Icon(Icons.camera_alt)),
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
                      onPressed: () {
                        sendMessage();
                      }),
                )
              : Container()
        ],
      ),
    );
  }

  sendMessage() {
    var text = textFieldController.text;

    Message _message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );

    setState(() {
      isWriting = false;
    });

    textFieldController.text = "";

    _chatMethods.addMessageToDb(_message, sender, widget.receiver);
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
        IconButton(
          icon: Icon(Icons.video_call),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? CallUtils.dial(
                      from: sender, to: widget.receiver, context: context)
                  : {},
        ),
        IconButton(icon: Icon(Icons.phone), onPressed: () {}),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function onTap;

  const ModalTile(
      {@required this.title,
      @required this.subTitle,
      @required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: CustomTile(
          mini: false,
          onTap: onTap,
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
