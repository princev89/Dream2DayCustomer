import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:customer/configView.dart';

class CardDetail extends StatefulWidget {
  final title;
  final category;
  final getlocation;
  final description;
  final phone;
  const CardDetail(
      {Key key,
      this.title,
      this.category,
      this.getlocation,
      this.description,
      this.phone})
      : super(key: key);

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  String distance;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_element
    double calculateDistance(lat1, lon1, lat2, lon2) {
      print('cal');
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      print(12742 * asin(sqrt(a)));
      return 12742 * asin(sqrt(a));
    }

    

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'category',
          style: secondaryText,
        ),
      ),
      body: SlidingUpPanel(
        panel: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: CupertinoColors.activeGreen,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 200,
                  height: 5,
                ),
              ),
            ),
            Center(
              child: Text(
                'Get in touch'.toUpperCase(),
                style: heading,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            if (distance != null) Text(distance),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      // launchMapsUrl(26.4922722, 83.8889526);
                      // calculateDistance(
                      //     26.771628, 83.369537, 26.380830, 83.418346);
                      setState(() {
                        distance = (Geolocator.distanceBetween(26.784179,
                                        83.368525, 26.764049, 83.374945)
                                    .ceil() /
                                1000)
                            .toString();
                      });
                    },
                    child: Icon(Icons.location_city))
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category'.toUpperCase(),
                    style: isDarkMode
                        ? GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)
                        : GoogleFonts.nunitoSans(
                            fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        '0.25 KM Away',
                        style: isDarkMode ? darkSecondaryText : secondaryText,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.home,
                        color: Colors.green,
                      )
                    ],
                  )
                ],
              ),
              Text(
                widget.title,
                style: isDarkMode ? darkworkCardHeading : workCardHeading,
              ),
              Text(
                'वायरिंग करने का तरीका: आज के समय में लगभग सभी घरों में इलेक्ट्रिक उपकरणों के इस्तेमाल किये जाते हैं। इन उपकरणों को power supply देने के लिए आपने भी बिजली का कनेक्शन जरूर ले रखा होगा। यदि आपने भी अपने घर में बिजली कनेक्शन लिया होगा तो आपने अपने घर की वायरिंग जरूर करवाया होगा। यदि आपने अभी तक अपने घर की वायरिंग नहीं करवाया है तो हो सकता है कि आप इसके लिए सोच रहे होंगे।',
                style: isDarkMode ? darkSecondaryText : workCardSecondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
