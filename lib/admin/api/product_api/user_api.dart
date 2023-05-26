import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/models/user_model.dart';

class UserApi {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future getUser(String id) async{
    var user = await users.doc(id).get();
    if (user.data() == null) {
      return null;
    }
    else {
      String userString = json.encode(user.data());
      UserModel userModel = UserModel.fromJson(jsonDecode(userString));
      return userModel;
    }
  }

  Future<void> addUser(UserModel userModel) {
    return users
        .doc(userModel.id)
        .set(userModel.toJson())
        .then((value) {})
        .catchError((error){
          throw error;
    });
  }

  Future<void> updateUser(UserModel userModel) {
    return users
        .doc(userModel.id)
        .set(userModel.toJson())
        .then((value) => print("User Updated"))
        .catchError((error){
      throw error;
    });
  }
}