import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//location
double longitude;
double latitude;

bool isDarkMode = false;

// Color mainColor = Color(0xfff3e8db);
Color mainColor = Colors.white;
var heading = GoogleFonts.nunitoSans(fontSize: 24);
var secondaryText =
    GoogleFonts.nunitoSans(fontSize: 16, color: CupertinoColors.secondaryLabel);

var workCardHeading = GoogleFonts.nunitoSans(fontSize: 20);
var workCardSecondaryText =
    GoogleFonts.nunitoSans(fontSize: 14, color: CupertinoColors.secondaryLabel);
var primaryBlue = Colors.blue;
//dark mode
Color darkMode = Color(0xff121212);
var darkheading = GoogleFonts.nunitoSans(
    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
var darkSecondaryText =
    GoogleFonts.nunitoSans(fontSize: 14, color: Color(0xffb3b3b3));
var darkworkCardHeading =
    GoogleFonts.nunitoSans(fontSize: 20, color: Colors.white);
var darkCard = Color(0xff404040);
