import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/pages/createAccount.dart';
import 'package:customer/pages/writereview.dart';
import 'package:customer/widgets/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../location.dart';
import 'package:customer/widgets/reviewbuilder.dart';

class ShopDetail extends StatefulWidget {
  final showingBookedShop;
  final shop;
  final service;
  final shopid;
  final requirment;

  const ShopDetail(
      {Key key,
      this.shop,
      this.service,
      this.shopid,
      this.requirment,
      this.showingBookedShop = false})
      : super(key: key);

  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  @override
  Widget build(BuildContext context) {
    DateTime todayDate;
    DateTime selectedDate = DateTime.now();

    List<String> services = [];
    for (var item in widget.shop['services']) {
      services.add(item);
    }
    // List<String> images = [
    //   'https://image.shutterstock.com/image-vector/abstract-futuristic-cyberspace-binary-code-260nw-740523562.jpg',
    //   'https://image.shutterstock.com/image-vector/abstract-futuristic-cyberspace-binary-code-260nw-740523562.jpg',
    //   'https://www.computersciencedegreehub.com/wp-content/uploads/2016/02/what-is-coding-1024x683.jpg'
    // ];
    Future<void> _selectDate(BuildContext context) async {
      todayDate = DateTime.now();
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: todayDate,
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    Widget _buildPopupDialog(BuildContext context, date, service) {
      FirebaseAuth auth = FirebaseAuth.instance;
      return new AlertDialog(
        title: const Text('Booking Detail'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Book  $service on  Date: $date"),
          ],
        ),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () async {
              showLoaderDialog(context, "Booking In Progress");
              List<dynamic> bookings = [];
              List<dynamic> customerBookings = [];
              int bookingid = DateTime.now().millisecondsSinceEpoch;

              CollectionReference agents =
                  FirebaseFirestore.instance.collection('agents');
              CollectionReference customer =
                  FirebaseFirestore.instance.collection('customer');
              CollectionReference bookingcollection =
                  FirebaseFirestore.instance.collection('bookings');

              // Call the user's CollectionReference to add a new user

              await agents
                  .doc(widget.shopid)
                  .get()
                  .then((value) => bookings = value.get('bookings'));

              bookings.add({
                "service": service,
                "date": date,
                "bookingid": bookingid,
                "booked": false
              });
              await agents
                  .doc(widget.shopid)
                  .update({'bookings': bookings}).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Requested"),
                ));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Try again."),
                ));
              });

              await customer
                  .doc(auth.currentUser.uid)
                  .get()
                  .then((value) => customerBookings = value.get('bookings'));

              customerBookings.add({
                "service": service,
                "date": date,
                "bookingid": bookingid,
                "booked": false
              });

              customer
                  .doc(auth.currentUser.uid)
                  .update({'bookings': customerBookings}).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("booked"),
                ));
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Try again."),
                ));
              });
//booking collection
              bookingcollection
                  .doc(bookingid.toString())
                  .set({
                    "service": service,
                    "serviceDate": date,
                    "bookingid": bookingid,
                    "customer": auth.currentUser.displayName,
                    "customerid": auth.currentUser.uid,
                    "shopid": widget.shopid,
                    "booked": false,
                    "customer_phone": auth.currentUser.phoneNumber
                  })
                  .then((value) => print("Booking Collection added Added"))
                  .catchError((error) =>
                      print("Failed to add Booking Collection added: $error"));

              //update booking for current customer

              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Book'),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Shop Detail',
              style: TextStyle(color: Colors.black),
            ),
            Expanded(child: SizedBox()),
            InkWell(
                child: Text(
                  'Review',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WriteReview(
                                shopid: widget.shopid,
                              )));
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            launch("tel://${widget.shop['secondary_phone']}");
          },
          child: Icon(Icons.call)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3366FF).withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                // gradient: LinearGradient(
                //   colors: [Color(0xffb6ccfe), Color(0xffe2eafc)],
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.shop['shop_name'] ?? "",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 18)),
                    SizedBox(height: 10),
                    Text(widget.shop['shop_description'] ?? "",
                        style: GoogleFonts.poppins(
                            color: Color(0xff222f6d),
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    SizedBox(height: 4),

                    Text(widget.shop['full_name'] ?? "",
                        style: GoogleFonts.poppins(
                            color: Color(0xff222f6d),
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    SizedBox(height: 2),

                    Text(widget.shop['address'] ?? "",
                        style: GoogleFonts.poppins(
                            color: Color(0xff222f6d),
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        // color: Color(0xff3d405b),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 3.0,
                          )
                        ],
                        gradient: LinearGradient(
                          colors: [Color(0xffb6ccfe), Color(0xffe2eafc)],
                        ),
                      ),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateAccount()));
                                } else {
                                  await _selectDate(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(
                                            context,
                                            selectedDate
                                                .toString()
                                                .substring(0, 11),
                                            services[index]),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Chip(
                                    backgroundColor: widget.service != null
                                        ? widget.service == services[index]
                                            ? Colors.green
                                            : Colors.white
                                        : Colors.white,
                                    label: Text(
                                      services[index],
                                      style: TextStyle(
                                          color: widget.service != null
                                              ? widget.service ==
                                                      services[index]
                                                  ? Colors.white
                                                  : Colors.black
                                              : Colors.black),
                                    )),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    if (widget.shop['shop_image'] != null)
                      Container(
                          height: 300,
                          width: double.infinity,
                          child: Image.network(
                            widget.shop['shop_image'],
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          )
                          // child: ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: images.length,
                          //     itemBuilder: (context, index) {
                          //       return Image.network(images[index]);
                          //       // return Text(images[index]);
                          //     }),
                          ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     if (widget.requirment != null)
                    //       RaisedButton(
                    //           color: Colors.green,
                    //           onPressed: () async {
                    //             List<dynamic> bookings = [];

                    //             CollectionReference agents = FirebaseFirestore
                    //                 .instance
                    //                 .collection('agents');

                    //             await agents.doc('${document.id}').get().then(
                    //                 (value) =>
                    //                     bookings = value.get('bookings'));

                    //             // await agents.get().then(
                    //             //     (QuerySnapshot querySnapshot) {
                    //             //   querySnapshot.docs.forEach((doc) {
                    //             //     print(doc["booking"]);

                    //             //     bookings = doc["booking"];
                    //             //   });
                    //             // });

                    //             bookings.add({
                    //               "service": widget.requirment,
                    //               "date": widget.date,
                    //               "bookingid": widget.bookingid,
                    //               "booked": false
                    //             });
                    //             print(bookings);

                    //             agents.doc(document.id).update(
                    //                 {'bookings': bookings}).then((value) {
                    //               ScaffoldMessenger.of(context)
                    //                   .showSnackBar(SnackBar(
                    //                 content: Text("Requested"),
                    //               ));
                    //             }).catchError((error) {
                    //               ScaffoldMessenger.of(context)
                    //                   .showSnackBar(SnackBar(
                    //                 content: Text("Try again."),
                    //               ));
                    //             });
                    //           },
                    //           child: Text(
                    //             'Request',
                    //             style: GoogleFonts.poppins(color: Colors.white),
                    //           ))
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (widget.shop['cordinates'] != null) {
                        var pos =
                            widget.shop['cordinates'].toString().split(',');

                        launchMapsUrl(
                            double.parse(pos[0]), double.parse(pos[1]));
                      } else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Location Unavailable."),
                        ));
                    },
                    child: Text('View Location')),
                if (widget.showingBookedShop == false)
                  ElevatedButton(
                      onPressed: () async {
                        if (FirebaseAuth.instance.currentUser == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAccount()));
                        } else {
                          if (widget.requirment != null) {
                            await _selectDate(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(
                                      context,
                                      selectedDate.toString().substring(0, 11),
                                      widget.requirment),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Select any service."),
                            ));
                          }
                        }

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Scaffold(
                        //               body: SafeArea(
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: Column(
                        //                     children: [
                        //                       Text(
                        //                           "Book on ${selectedDate.toString().substring(0, 11)}"),
                        //                       CupertinoButton(
                        //                           child: Text('Book'),
                        //                           onPressed: () {})
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             )));
                      },
                      child: Text('Book Now'))
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Ratings & Reviews',
                  style: GoogleFonts.poppins(fontSize: 20)),
            ),
            Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ReviewBuilder(
                  shopid: widget.shopid,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
