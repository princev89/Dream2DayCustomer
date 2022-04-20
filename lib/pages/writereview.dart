import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteReview extends StatefulWidget {
  final shopid;
  WriteReview({Key key, this.shopid}) : super(key: key);

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  CollectionReference users = FirebaseFirestore.instance.collection('reviews');
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addReview(review, user, rating, shopid) {
    return users.add({
      'user': user,
      'review': review,
      'rating': rating,
      'shop_id': shopid,
      'reviewed_by': auth.currentUser.displayName
    }).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context),
      );
    }).catchError((error) => print("Failed to add Review: $error"));
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Color(0xfff6f6f6),
      title: const Text('Reviewed Successfuly!!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Image.asset('assets/done.gif')],
      ),
      actions: <Widget>[
        // ignore: deprecated_member_use
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var userRating;
    var reviewText;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Write Review',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 200,
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (value) {
                    reviewText = value;
                  },
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          'More detailed reviews get more visibility....'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber[200],
              ),
              onRatingUpdate: (rating) {
                userRating = rating;
              },
            ),
            SizedBox(
              height: 10,
            ),
            CupertinoButton(
                color: Colors.green,
                child: Text('Review'),
                onPressed: () {
                  print(reviewText);
                  print(userRating);
                  if (userRating == null) userRating = 2.5;
                  addReview(reviewText, auth.currentUser.uid, userRating,
                      widget.shopid);
                }),
          ],
        ),
      ),
    );
  }
}
