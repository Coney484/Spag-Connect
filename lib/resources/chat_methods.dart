import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spag_connect/constants/strings.dart';
import 'package:spag_connect/models/message.dart';
import 'package:spag_connect/models/userModel.dart';

class ChatMethods {

  static final Firestore _firestore = Firestore.instance;


   Future<void> addMessageToDb(
      Message message, UserModel sender, UserModel receiver) async {
    var map = message.toMap();

    await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    return await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }



   void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;
    _message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    var map = _message.toImageMap();

    // set the data to database
    await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await _firestore
        .collection(MESSAGES_COLLECTION)
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }


}