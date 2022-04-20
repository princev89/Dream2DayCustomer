import 'dart:async';

import 'package:customer/widgets/textlogo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configView.dart';
import 'package:timer_button/timer_button.dart';

import 'package:url_launcher/url_launcher.dart';

int currentIndex = 0;

class CreateAccount extends StatefulWidget {
  final phone;
  const CreateAccount({Key key, this.phone}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  // String phone;
  String otpCode;
  String verificationId;
  DateTime selectedDate = DateTime.now();
  String name;
  Position _currentPosition;
  String address;
  String city;
  List<String> professions = [];
  List<bool> professionsSelected = [false, false, false, false, false];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isNextClicked;
  bool isVerifyClicked;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      // do whatever you want based on the firebaseUser state
      if (firebaseUser != null) {
        setState(() {
          currentIndex = 2;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List screens = [signUp(widget.phone), otp(), setProfile()];

    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: TextLogo(),
          elevation: 0.5,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 35, top: 10),
          child: screens[currentIndex],
        )));
  }

  Widget signUp(phone) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
                height: 150,
                width: 150,
                child: Image.asset('assets/profile.png')),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'enter_phone',
            style: heading,
          ).tr(),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black12,
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  onChanged: (value) {
                    phone = value;
                  },
                  initialValue: phone != null ? phone : null,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'phone_number'.tr(),
                  ),
                )),
          ),
          SizedBox(
            height: 40,
          ),
          Text.rich(
            TextSpan(
              text: 'By entering your number, you\'re agreeing to our ',
              style: GoogleFonts.poppins(fontSize: 22),
              children: <TextSpan>[
                TextSpan(
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () async => await launch(
                          'http://dream2day.org/termsandconditon.html'),
                    text: 'Terms of Service and Privacy Policy',
                    style: GoogleFonts.lato(
                        color: Color(0xff0645AD),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text: '. Thanks!',
                    style: GoogleFonts.poppins(fontSize: 22)),
              ],
            ),
          ),
          // Text(
          //   'phone_privacy_text',
          //   style: secondaryText,
          // ).tr(),
          SizedBox(
            height: 30,
          ),
          Center(
            child: CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: primaryBlue,
                child: isNextClicked == true
                    ? SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text('next').tr(),
                onPressed: () async {
                  setState(() {
                    isNextClicked == true
                        ? isNextClicked = false
                        : isNextClicked = true;
                    print(isNextClicked);
                  });
                  if (phone.length == 10) phone = '+91' + phone;
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phone,
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                      await auth.signInWithCredential(credential);
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      if (e.code == 'invalid-phone-number') {
                        print('The provided phone number is not valid.');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content:
                              Text("The provided phone number is not valid."),
                        ));
                        setState(() {
                          isNextClicked = false;
                        });
                      }
                    },
                    codeSent: (String verificationId, int resendToken) async {
                      print("verificationId is " + verificationId);
                      this.verificationId = verificationId;
                      setState(() {
                        //ask for otp
                        currentIndex = 1;
                      });
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget otp() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/text_message.png')),
          Text(
            'enter_otp',
            style: heading,
          ).tr(),
          Text(
            'otp_info',
            style: secondaryText,
          ).tr(),
          if (widget.phone != null)
            Text(
              widget.phone,
              style: secondaryText,
            ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black12,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    otpCode = value;
                  });
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly
                ],
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '#  #  #  #  #  #'),
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: primaryBlue,
                child: isVerifyClicked == true
                    ? SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text('verify').tr(),
                onPressed: () async {
                  setState(() {
                    isVerifyClicked == true
                        ? isVerifyClicked = false
                        : isVerifyClicked = true;
                    print(isVerifyClicked);
                  });
                  print(verificationId);
                  print(otpCode);
                  await codeIsSent(otpCode);
                }),
          ),
          SizedBox(height: 30),
          TimerButton(
            buttonType: ButtonType.FlatButton,
            label: 'resend_otp'.tr(),
            timeOutInSeconds: 30,
            onPressed: () async {
              setState(() {
                isVerifyClicked = false;
              });
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: widget.phone,
                verificationCompleted: (PhoneAuthCredential credential) async {
                  await auth.signInWithCredential(credential);
                },
                verificationFailed: (FirebaseAuthException e) {
                  if (e.code == 'invalid-phone-number') {
                    print('The provided phone number is not valid.');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("The provided phone number is not valid."),
                    ));
                    setState(() {
                      isNextClicked = false;
                    });
                  }
                },
                codeSent: (String verificationId, int resendToken) async {
                  print("verificationId is " + verificationId);
                  this.verificationId = verificationId;
                  setState(() {
                    //ask for otp
                    currentIndex = 1;
                  });
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
              );
            },
            color: Colors.orange,
            disabledTextStyle: TextStyle(color: CupertinoColors.secondaryLabel),
          ),
        ],
      ),
    );
  }

  codeIsSent(String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await auth.signInWithCredential(credential);
    if (auth.currentUser != null) {
      setState(() {
        //open update profile
        currentIndex = 2;
      });
    }
  }

  Widget setProfile() {
    CollectionReference customer =
        FirebaseFirestore.instance.collection('customer');
    updateaddress(x, y) async {
      final coordinates = new Coordinates(x, y);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      city = first.subAdminArea;
      address = first.addressLine;
      print(city);
    }

    // ignore: unused_element
    Future<void> getCurrentLocation() async {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        print(position);
        setState(() {
          _currentPosition = position;
          updateaddress(position.latitude, position.longitude);
        });
      }).catchError((e) {
        print(e);
      });
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'enter_your_name',
            style: heading,
          ).tr(),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black12,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                onChanged: (value) {
                  name = value;
                  print(name);
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'your_name'.tr()),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 20,
          ),
          CupertinoButton(
            color: Colors.black12,
            child: address != null
                ? Text(
                    address + ", " + city,
                    style: secondaryText,
                  )
                : Text(
                    'update_location',
                    style: secondaryText,
                  ).tr(),
            onPressed: () {
              getCurrentLocation();
              setState(() {});
            },
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: primaryBlue,
                child: Text('update').tr(),
                onPressed: () {
                  print('updating');
                  auth.currentUser.updateDisplayName(name);
                  // customer.doc(auth.currentUser.phoneNumber).set({
                  customer.doc(auth.currentUser.uid).set({
                    'full_name': name,
                    'city': city,
                    'bookings': [],
                    'address': address,
                    'cordinates': _currentPosition.latitude.toString() +
                        ", " +
                        _currentPosition.longitude.toString(),
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Login Successfully Continue Booking."),
                    ));
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    print(error);
                  });
                }),
          )
        ],
      ),
    );
  }
}
