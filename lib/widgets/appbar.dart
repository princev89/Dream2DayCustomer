import 'package:customer/pages/createAccount.dart';
import 'package:customer/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget {
  final title;
  const CustomAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Color(0xFF3366FF).withOpacity(0.8),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      height: 60,
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () async {},
          //   child: SizedBox(
          //     height: 45,
          //     // child: Image.asset('assets/background.png', fit: BoxFit.cover)
          //     child: Text('Dream2Day'),
          //   ),
          // ),
          if (title != null)
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                )),
          SizedBox(
            width: 20,
          ),
          title != null
              ? Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                )
              : Text.rich(
                  TextSpan(
                    text: 'Dream',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '2',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          )),
                      TextSpan(
                          text: 'Day',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
          Expanded(child: SizedBox()),
          auth.currentUser == null
              ? Visibility(
                  visible: title == null,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccount()));
                      },
                      icon: Icon(
                        Icons.login,
                        color: Colors.white,
                      )),
                )
              : Visibility(
                  visible: title == null,
                  child: IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        await auth.signOut();
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        await preferences.clear();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      )),
                )
        ],
      ),
    );
  }
}
