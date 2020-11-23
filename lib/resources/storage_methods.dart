import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/provider/image_upload_provider.dart';
import 'package:spag_connect/resources/chat_methods.dart';

class StorageMethods {

   //User class
  UserModel userModel = UserModel();


  StorageReference _storageReference;

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);

      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();

      print(url);

      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();
    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide Loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }
}
