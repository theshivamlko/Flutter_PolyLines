import 'package:enrich/utils/Firebase.dart' as fbUtils;
import 'package:enrich/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'MapPage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController =
      TextEditingController(text: "din@gmail.com");
  TextEditingController passController = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {


    Utils.deviceWidth = MediaQuery.of(context).size.width;
    Utils.deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: Utils.deviceWidth,
        color: Utils.colorWhite,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Image.asset('assets/images/football.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 35),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                        decoration: InputDecoration(
                            hintText: "Inserisci la tua email",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Utils.blackColor, fontSize: 20),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Utils.greyColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid))),
                        controller: nameController,
                        style: TextStyle(fontSize: 23)),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Inserisci la tua password",
                            hintStyle: TextStyle(fontSize: 20),
                            labelText: "Password",
                            labelStyle: TextStyle(
                                color: Utils.blackColor, fontSize: 20),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Utils.greyColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Utils.greyColor))),
                        style: TextStyle(
                          fontSize: 23,
                        ),
                        controller: passController),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Password dimenticata ?",
                        style: TextStyle(color: Utils.greyColor, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                height: 50,
                margin: EdgeInsets.only(bottom: 30, top: 40),
                child: RaisedButton(
                    onPressed: () {
                      login(nameController.text, passController.text);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Utils.colorWhite, fontSize: 20.0),
                    ),
                    color: Utils.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              ),
              Text(
                "oppure",
                style: TextStyle(color: Utils.greyColor),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              "assets/images/google.png",
                              scale: 2,
                            ),
                          )),
                      onTap: () {
                        loginViaGoogle();
                      },
                    ),
                    GestureDetector(
                      child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              "assets/images/fb.png",
                              scale: 2,
                            ),
                          )),
                      onTap: () {
                        fbLogin();
                      },
                    ),

                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Non hai un account ?"),
                      Text(
                        "SignUp",
                        style: TextStyle(color: Utils.blueColor),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void login(String email, String password) {
    fbUtils.login(email, password).then((value) {
      if (value != null) {

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MapPage()));

      } else {
        print(Exception);
      }
    }).catchError((error) {
      Utils.showMessage(Utils.getTranslation("invalidUserNPass"));

      print(error);
    });
  }


  void loginViaGoogle() {
    try {
      Utils.api.googleInfo().then((b) {
        if (b) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MapPage()));
        }
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  void fbLogin() {
    try {
      Utils.api.facebookInfo().then((b) {
        if (b) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MapPage()));
        }
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }
}
