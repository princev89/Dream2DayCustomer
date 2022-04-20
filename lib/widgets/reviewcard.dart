import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class Review extends StatelessWidget {
  final star;
  final title;
  final content;
  const Review({Key key, this.star, this.title, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Card(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      star.toString(),
                      style: GoogleFonts.lato(fontSize: 25),
                    ),
                    RatingBarIndicator(
                        rating: 2.75,
                        itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                        itemCount: 1,
                        itemSize: 22.0,
                        direction: Axis.horizontal),
                    SizedBox(width: 10),
                    Text(
                      title ?? 'Anonymous',
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(content)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
