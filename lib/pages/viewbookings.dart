import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/pages/manageBookings.dart';
import 'package:customer/pages/shopdetail.dart';
import 'package:customer/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class ViewBooking extends StatefulWidget {
  final city;
  const ViewBooking({Key key, this.city}) : super(key: key);

  @override
  _ViewBookingState createState() => _ViewBookingState();
}

class _ViewBookingState extends State<ViewBooking> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference bookings =
        FirebaseFirestore.instance.collection('bookings');

    Future<void> deleteBooking(docid) {
      return bookings
          .doc(docid)
          .delete()
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Booking Deleted."),
              )))
          .catchError(
              (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Try Again."),
                  )));
    }

    final Stream<QuerySnapshot> _bookingStream = FirebaseFirestore.instance
        .collection('bookings')
        // .collection(widget.city)
        .where('customerid', isEqualTo: auth.currentUser.uid)
        .orderBy('serviceDate')
        .snapshots();

    showAlertDialog(String docid) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: Text(
          "Continue",
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          deleteBooking(docid);
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(
          "Warning",
          style: TextStyle(color: Colors.red),
        ),
        content:
            Text("Would you like to delete. Booking will not be recovered."),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffedf2fb),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(500),
          child: CustomAppBar(
            title: 'Your Bookings',
          )),
      // appBar: AppBar(
      //   leading: GestureDetector(
      //       onTap: () {
      //         Navigator.of(context).pop();
      //       },
      //       child: Icon(Icons.arrow_back, color: Colors.black)),
      //   title: Text('Your Bookings ',
      //       style: GoogleFonts.poppins(
      //         color: Colors.black,
      //         fontSize: 22,
      //         fontWeight: FontWeight.w400,
      //       )),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bookingStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return GestureDetector(
                onPanUpdate: (details) {
                  // Swiping in left direction.
                  if (details.delta.dx < 0) {
                    print('l');
                    Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(milliseconds: 200),
                            type: PageTransitionType.rightToLeft,
                            child: ManageBooking(
                              data: data,
                              city: widget.city,
                              bookingid: document.id,
                            )));
                  }
                },
                child: InkWell(
                  onTap: () async {
                    print(data['shopid']);
                    await FirebaseFirestore.instance
                        .collection('agents')
                        .doc(data['shopid'])
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        print(
                            'Document exists on the database ${documentSnapshot.data()}');
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 200),
                                type: PageTransitionType.rightToLeft,
                                child: ShopDetail(
                                  showingBookedShop: true,
                                  service: data['service'],
                                  shop: documentSnapshot.data(),
                                  shopid: data['shopid'],
                                  requirment: data['service'],
                                )));
                      } else {
                        print("no data found");
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 8.0,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [Color(0xffb6ccfe), Color(0xffe2eafc)],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['serviceDate'],
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff222f6d),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                              Text(data['service'],
                                  style: GoogleFonts.poppins(
                                    color: Color(0xff222f6d),
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Icon(Icons.map_outlined, color: Colors.green),
                        // ),
                        // SizedBox(
                        //   width: 30,
                        // ),
                        GestureDetector(
                          onTap: () {
                            showAlertDialog(document.id);
                          },
                          child: Icon(Icons.delete, color: Colors.red),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
