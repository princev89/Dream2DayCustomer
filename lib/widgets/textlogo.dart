import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextLogo extends StatelessWidget {
  const TextLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Dream',
        style: GoogleFonts.poppins(
          color: Colors.orange,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
              text: '2',
              style: GoogleFonts.lato(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 38,
              )),
          TextSpan(
              text: 'Day',
              style: GoogleFonts.poppins(
                color: Colors.orange,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
