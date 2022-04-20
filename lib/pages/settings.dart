import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer/configView.dart';
import 'package:customer/pages/createAccount.dart';

class UpdateSetting extends StatelessWidget {
  const UpdateSetting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Update Setting',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: isDarkMode ? darkMode : mainColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Update Profile',
                ),
              ),
              CupertinoButton(
                  child: Text('Logout'),
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAccount()));
                  })
            ],
          ),
        ));
  }
}
