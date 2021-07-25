import 'package:citimark0710/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:citimark0710/database.dart';
import 'helperfunctions.dart';
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController  UserNameTextEditingController = new TextEditingController();
  TextEditingController  UserPhoneTextEditingController = new TextEditingController();
  String phoneNo, verificationId,smsCode;
  bool codeSent =false;

  // Update data to server if new user
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
    HelperFunctions.saveUserPhoneSharedPreference(UserPhoneTextEditingController.text);
  }
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
    Map<String, String> userInfoMap = {
      "phone": UserPhoneTextEditingController.text,
      "name": UserNameTextEditingController.text,
    };
    databaseMethods.uploadUserInfo(userInfoMap);
    HelperFunctions.saveUserLoggedInSharedPreference(true);
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blue.withOpacity(0.9),
          body: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'enter name',hintStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontStyle: FontStyle.italic)),
                        controller: UserNameTextEditingController,
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(prefix: Text('+91'),hintText: 'enter phone number',hintStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontStyle: FontStyle.italic)),
                        controller: UserPhoneTextEditingController,
                        onChanged: (val) {
                          setState(() {
                            this.phoneNo = val;
                          });
                        },
                      )
                  ),
                  codeSent ? Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(hintText: 'enter OTP',hintStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontStyle: FontStyle.italic)),
                        onChanged: (val) {
                          setState(() {
                            this.smsCode = val;
                          });
                        },
                      )
                  ) : Container(),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Center(
                          child: codeSent ? Text('login',style: TextStyle(fontSize:17,fontStyle: FontStyle.italic),) : Text('verify',style:TextStyle(fontSize:17,fontStyle: FontStyle.italic))),
                      onPressed: () {
                        codeSent ? signInWithOTP(
                            smsCode, verificationId) : verifyPhone(phoneNo);
                      },
                    ),
                  ),
                ],
              )
          )
      );
    }
    Future<void> verifyPhone(phoneNo) async {
      final PhoneVerificationCompleted verified = (AuthCredential authResult) {
        signIn(authResult);
      };
      final PhoneVerificationFailed verificationfailed = (
          AuthException authException) {
        print('${authException.message}');
      };
      final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
        this.verificationId = verId;
        setState(() {
          this.codeSent = true;
        });
      };
      final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
        this.verificationId = verId;
      };
      await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: phoneNo,
          timeout: const Duration(seconds: 50),
          verificationCompleted: verified,
          verificationFailed: verificationfailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout);
    }
  }

