import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer/configView.dart';

class WorkCard extends StatefulWidget {
  final agentLon;
  final agentLat;
  final category;
  final title;
  final description;
  final phone;
  final position;

  const WorkCard(
      {Key key,
      this.position,
      this.category,
      this.title,
      this.description,
      this.phone,
      this.agentLon,
      this.agentLat})
      : super(key: key);

  @override
  _WorkCardState createState() => _WorkCardState();
}

class _WorkCardState extends State<WorkCard> {
  String distance;

  @override
  Widget build(BuildContext context) {
    GeoPoint geo = widget.position;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          print('hello' + geo.longitude.toString() + geo.latitude.toString());

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => CardDetail(
          //               title: widget.title,
          //             )));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: isDarkMode ? darkCard : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.transparent : Colors.grey,
                  blurRadius: 10.0,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.category.toUpperCase(),
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
                        if (distance != null)
                          Text(
                            distance + ' KM Away',
                            style:
                                isDarkMode ? darkSecondaryText : secondaryText,
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            print(Geolocator.distanceBetween(
                                26.49473, 83.779039, 26.4945971, 83.8862283));
                          },
                          child: Icon(
                            Icons.home,
                            color: Colors.green,
                          ),
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
                  widget.description,
                  style: isDarkMode ? darkSecondaryText : workCardSecondaryText,
                ),
                Row(
                  children: [Icon(Icons.call)],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
