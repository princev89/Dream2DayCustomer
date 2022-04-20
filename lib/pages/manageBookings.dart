import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ManageBooking extends StatefulWidget {
  final data;
  final bookingid;
  final city;
  ManageBooking({Key key, this.data, this.city, this.bookingid})
      : super(key: key);

  @override
  _ManageBookingState createState() => _ManageBookingState();
}

class _ManageBookingState extends State<ManageBooking> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (details) {
          // Swiping in right direction.
          if (details.delta.dx > 0) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xfff5f6fa),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(widget.data['service']),
                  Text(widget.data['customer']),
                  Text(widget.data['serviceDate']),
                  CupertinoButton(
                      color: Colors.green,
                      child: Text('Visit Shop'),
                      onPressed: () {})
                ],
              ),
            ),
          ),
        ));
  }
}
