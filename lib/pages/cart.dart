import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/pages/createAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Cart extends StatefulWidget {
  final items;

  Cart({Key key, this.items}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String city;
  String phone;
  FirebaseAuth auth = FirebaseAuth.instance;
  Position currentPosition;
  String address;
  DateTime todayDate;
  DateTime selectedDate = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
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

  Future<void> getCurrentLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      print(position);
      setState(() {
        currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  iscity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      city = prefs.getString('city');
    });
  }

  @override
  void initState() {
    super.initState();
    iscity();
    getCurrentLocation();
    todayDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        title: Text('Cart Page ',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w400,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Order In:  $city',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                )),
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (context, i) {
                      return Card(
                        elevation: 2,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.items[i]),
                                Icon(
                                  Icons.done,
                                  color: Colors.green,
                                )
                              ],
                            )),
                      );
                    }),
              ),
            ),
            // CupertinoButton(
            //   color: Colors.black12,
            //   child: address != null
            //       ? Text(
            //           address + ", " + city,
            //           style: secondaryText,
            //         )
            //       : Text(
            //           'update_location',
            //           style: secondaryText,
            //         ).tr(),
            //   onPressed: () {
            //     getCurrentLocation();
            //     setState(() {});
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
                placeholder: '+91 123456789 (Phone Secondary)',
              ),
            ),
            CupertinoButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Selected Date'),
                    SizedBox(width: 5),
                    Icon(Icons.date_range_rounded)
                  ],
                ),
                onPressed: () => _selectDate(context)),
            CupertinoButton(
                color: Colors.green,
                child:
                    Text("Book on ${selectedDate.toString().substring(0, 11)}"),
                onPressed: () {
                  List needs = [];

                  for (var item in widget.items) {
                    needs.add({
                      "item": item,
                      "bookedto": null,
                      "agent_phone": null,
                    });
                  }
                  print(needs);

                  auth.currentUser != null ? makeOrder(needs) : createUser();
                }),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Future<void> makeOrder(needs) {
    print(needs);
    CollectionReference bookings =
        FirebaseFirestore.instance.collection('bookings');

    return bookings.add({
      'user_phone': auth.currentUser.phoneNumber,
      'secondary_phone': phone,
      'postby': auth.currentUser.displayName,
      // 'location': GeoPoint(latitude, longitude),
      'requirments': needs,
      'booked_on': todayDate,
      'city': city,
      'booking_date': selectedDate.toString().substring(0, 11)
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Booking Posted."),
      ));
      Navigator.pop(context);
    }).catchError((error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong."),
      ));
    });
  }

  createUser() async {
    // print('create user');
    // SmsAutoFill _autoFill = SmsAutoFill();
    // final completePhoneNumber = await _autoFill.hint;
    // print(completePhoneNumber);
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Phone no is to short."),
      ));
    } else {
      if (phone.length == 10) phone = "+91" + phone;
      Navigator.push(
          context,
          PageTransition(
              duration: Duration(milliseconds: 600),
              type: PageTransitionType.bottomToTop,
              child: CreateAccount(phone: phone)));
    }
  }
}

class ServiceBook {
  String name;
  bool isBooked;
  String bookedto;
  String agentPhone;

  ServiceBook(this.name, this.isBooked, this.bookedto, this.agentPhone);

  @override
  String toString() {
    return '{ ${this.name}, ${this.isBooked} }';
  }
}
