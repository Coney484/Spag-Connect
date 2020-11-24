import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spag_connect/constants/strings.dart';
import 'package:spag_connect/enum/user_state.dart';
import 'package:spag_connect/models/userModel.dart';
import 'package:spag_connect/utils/utilities.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  static final Firestore _firestore = Firestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  //User class
  UserModel userModel = UserModel();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<UserModel> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return UserModel.fromMap(documentSnapshot.data);
  }

  Future<UserModel> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.document(id).get();
      return UserModel.fromMap(documentSnapshot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> signIn() async {
    final GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    // final AuthCredential credential
    AuthResult result = await _auth.signInWithCredential(credential);

    return result.user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await _firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    // if user is registered then length of list > 0 or less than 0

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    userModel = UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    await _firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(userModel.toMap(userModel));
  }

  Future<List<UserModel>> fetchAllUsers(FirebaseUser currentUser) async {
    List<UserModel> userList = List<UserModel>();
    QuerySnapshot querySnapshot =
        await _firestore.collection(USERS_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(UserModel.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.document(userId).updateData({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.document(uid).snapshots();
}
