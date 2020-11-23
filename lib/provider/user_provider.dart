import 'package:flutter/cupertino.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;
  // FirebaseRepository _firebaseRepository = FirebaseRepository();
  AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _user;

  void refreshUser() async {
    // Future<UserModel> user = _firebaseRepository.getUserDetails();
    // _user = user as UserModel;

    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
