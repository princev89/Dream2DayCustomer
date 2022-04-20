import 'package:flutter/material.dart';

import '../configView.dart';

class ServiceCard extends StatelessWidget {
  final title;
  final imgPath;
  const ServiceCard({Key key, this.title, this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: isDarkMode ? darkCard : Color(0xfff8f8f8),
              borderRadius: BorderRadius.circular(20)),
          width: 100,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset(imgPath),
                ),
                Text(
                  title,
                  style: isDarkMode ? darkSecondaryText : secondaryText,
                )
              ])),
    );
  }
}
