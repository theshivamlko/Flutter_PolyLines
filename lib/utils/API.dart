import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Utils.dart';

class API {
  Future<bool> facebookInfo() async {
    final _auth = await FirebaseAuth.instance;

    final facebookLogin = FacebookLogin();
    final result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);

    FacebookAccessToken myToken = result.accessToken;

    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: myToken.token);

    FirebaseUser firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        Utils.registerModel.txtFieldValue = false;
        Utils.registerModel.source = "facebook";
        Utils.registerModel.email = firebaseUser.email;
        //    Utils.registerModel.googleToken = firebaseUser.idToken;
        Utils.registerModel.username = firebaseUser.displayName;
        Utils.registerModel.uuid = firebaseUser.uid;

        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        Utils.showMessage(FacebookLoginStatus.error.toString());
        break;
    }
    return true;
  }

  Future<bool> googleInfo() async {
    print("error");

    final _auth = await FirebaseAuth.instance;

    GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);

    Utils.registerModel.txtFieldValue = false;
    Utils.registerModel.source = "google";
    Utils.registerModel.email = user.email;
    Utils.registerModel.googleToken = googleAuth.idToken;
    Utils.registerModel.username = user.displayName;
    final FirebaseUser currentUser = await _auth.currentUser();

    Utils.registerModel.uuid = currentUser.uid;

    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user ${Utils.registerModel.uuid}');
    print(user.email);

    return true;
  }

  Future<List> getLocation() async {
    try {
      Dio dio = new Dio();
      Response response = await dio.get(
        'https://demo6.free.beeceptor.com/location',
      );

      if (response.statusCode == 200 && response.data != null) {
        print(response.data);

        Map map = response.data;
        List mainList = List();
        List tempList = map['data'];

        for (Map map in tempList) {
          print('Map $map');

          List latlon = map['location'];

          List<LatLng> polylineList = List();

          for (Map map in latlon) {
            print('----------${map['lat']} ${map['lon']}');
            polylineList.add(LatLng(map['lat'], map['lon']));
          }

          map['polyline'] = Polyline(
              polylineId: PolylineId(map['date']),
              points: polylineList,
              color: Colors.red);
/*
          var v = Polyline(
              polylineId: PolylineId(map['date']),
              points: polylineList,
              color: Colors.red);*/

          mainList.add(map);
        }

        return mainList;
      }
      print('searchCustomer Else ');
      return null;
    } catch (e) {
      print('searchCustomer Else $e');
    }
  }
}
