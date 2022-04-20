import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:customer/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateLocal extends StatefulWidget {
  UpdateLocal({Key key}) : super(key: key);

  @override
  _UpdateLocalState createState() => _UpdateLocalState();
}

class _UpdateLocalState extends State<UpdateLocal> {
  String cityValue;
  String countryValue;
  String stateValue;

  CollectionReference users = FirebaseFirestore.instance.collection('customer');
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> updateCity(city) {
    return users
        .doc(auth.currentUser.uid)
        .update({'city': city})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('I want my bookings in',
                style: GoogleFonts.lato(
                    fontSize: 28, fontWeight: FontWeight.w400)),
          ),
          Image.asset('assets/map_location.png'),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CSCPicker(
                    defaultCountry: DefaultCountry.India,
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value;
                      });
                    },
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoButton(
                color: Colors.orange,
                child: Text('Update'),
                onPressed: () async {
                  print(cityValue);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    prefs.setString('city', cityValue);
                  });
                  await updateCity(cityValue);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
