//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../controllers/user_controller.dart';
import 'login.dart';
import 'package:mvc_pattern/mvc_pattern.dart';



import './otp_input.dart';

class OTPScreen extends StatefulWidget {

  final String mobileNumber;
  final String email;
  final String name;
  final String password;
  OTPScreen({
    this.name,
    this.password,
    this.email,
    Key key,
    @required this.mobileNumber,
  })  : assert(mobileNumber != null),
        super(key: key);



  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends StateMVC<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.black);

  bool isCodeSent = false;
  String _verificationId;
  UserController _con;

  _OTPScreenState() : super(UserController()) {
    _con = controller;
  }



  @override
  void initState() {
    super.initState();
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    //ey: _con.scaffoldKey;
    //_con.scaffoldKey= widget.scaffold;
   // _con.loginFormKey= widget.form;
   // _con.user.name= widget.name;


   // _con.user.name = widget.name;
   // _con.user.password= widget.password;
   // _con.user.email = widget.email;
   // _con.user.phone = widget.mobileNumber;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          child: Container(
            padding: EdgeInsets.only(left: 16.0, bottom: 16, top: 4),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Verify Details",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "OTP sent to ${widget.mobileNumber}",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(100),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PinInputTextField(
                pinLength: 6,
                decoration: _pinDecoration,
                controller: _pinEditingController,
                autoFocus: true,
                textInputAction: TextInputAction.done,
                onSubmit: (pin) {
                  if (pin.length == 6) {
                    _onFormSubmitted();
                  } else {
                    showToast("Invalid OTP", Colors.red);
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    child: Text(
                      "ENTER OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _onFormSubmitted();

                    /*  if (_pinEditingController.text.length == 6) {
                        _con.register();
                        _onFormSubmitted();
                      } else {
                        showToast("Invalid OTP", Colors.red);
                      }

                     */
                    },


                    padding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: Colors.orange,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) {
        if (value.user != null) {


          // Handle loogged in state
          print(value.user.phoneNumber);
          print("verifycode");
          print("name ${widget.name}");
          print("password ${widget.password}");
          print("email ${widget.email}");
          print("mobiel ${widget.mobileNumber}");
          _con.user.name = widget.name;
          _con.user.password= widget.password;
          _con.user.email = widget.email;
          _con.user.phone = widget.mobileNumber;
          print("--------------------");
          print("name ${_con.user.name}");
          print("password ${_con.user.password}");
          print("email ${_con.user.email}");
          print("mobiel ${_con.user.phone}");
          _con.register();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginWidget() //HomeScreen()
                //  user: value.user,
               // ),
              ),
              (Route<dynamic> route) => false);
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
        //_con.register();
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };



    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    print("on form submitted");
    print("name ${widget.name}");
    print("password ${widget.password}");
    print("email ${widget.email}");
    print("mobiel ${widget.mobileNumber}");
    _con.user.name = widget.name;
    _con.user.password= widget.password;
    _con.user.email = widget.email;
    _con.user.phone = widget.mobileNumber;


    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);
    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((UserCredential value) {
      if (value.user != null) {
        // Handle loogged in state
        _con.register();
        print(value.user.phoneNumber);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginWidget(), //HomeScreen()
              /*HomePage(
                user: value.user,
              ),*/

            ),
            (Route<dynamic> route) => false);
      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.red);
    });
  }
}
