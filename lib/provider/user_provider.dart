import 'package:flutter/cupertino.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  UserModel get getUser => _user;

  void refreshUser() async {
    Future<UserModel> user = _firebaseRepository.getUserDetails();
    _user = user as UserModel;
    notifyListeners();
  }
}
