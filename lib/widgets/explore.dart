import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:customer/widgets/workcard.dart';

class Explore extends StatefulWidget {
  final currentPosition;
  final area;
  final professionals;
  Explore({Key key, this.currentPosition, this.area, this.professionals})
      : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection(widget.area).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong' + snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              strokeWidth: 2.0,
            ),
          );
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return WorkCard(
              category: data['category'],
              title: data['title'],
              description: data['description'],
              phone: data['phone'],
              position: data['position'],
            );
          }).toList(),
        );
      },
    );
  }
}
