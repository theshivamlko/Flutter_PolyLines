import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
 import 'package:enrich/utils/AppConstant.dart' as AppConstants;
import 'package:enrich/utils/Utils.dart';

Future<String> login(String emails, String passwords) async {
  try {
    final firebaseUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emails, password: passwords);
    Utils.registerModel.uuid = firebaseUser.uid;

    return firebaseUser.uid;
  } catch (e) {
    throw (e);
  }
}


Future<bool> register(String email, String pass, String name) async {
  try {
    final firebaseAuth = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);
    firebaseAuth.sendEmailVerification();


    return true;
  } catch (e) {
    throw (e);
  }
}

