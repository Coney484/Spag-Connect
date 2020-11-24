import 'package:flutter/cupertino.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;
  
  AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _user;

  Future<void> refreshUser() async {
   

    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
