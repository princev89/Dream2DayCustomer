import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/pages/shopdetail.dart';
import 'package:customer/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgentNearMe extends StatefulWidget {
  final city;
  final requirment;
  final date;
  //booking is collection doc  uid
  final bookingid;
  AgentNearMe({Key key, this.city, this.requirment, this.bookingid, this.date})
      : super(key: key);

  @override
  _AgentNearMeState createState() => _AgentNearMeState();
}

class _AgentNearMeState extends State<AgentNearMe> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance;
    final Stream<QuerySnapshot> _agentStream = FirebaseFirestore.instance
        .collection('agents')
        .where('city', isEqualTo: widget.city)
        .where('services', arrayContains: widget.requirment)
        .snapshots();
    return Scaffold(
      backgroundColor: Color(0xffedf2fb),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(500),
          child: CustomAppBar(
            title: 'Agent Near Me',
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: _agentStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          return snapshot.data.size == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                          "Sorry to say, not agent found for ${widget.requirment} in ${widget.city}",
                          style: GoogleFonts.poppins(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                )
              : ListView(
                  physics: BouncingScrollPhysics(),
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopDetail(
                                    requirment: widget.requirment,
                                    shopid: document.id,
                                    shop: data,
                                    service: widget.requirment)));
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF3366FF).withOpacity(0.1),
                              spreadRadius: 4,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [Color(0xffb6ccfe), Color(0xffe2eafc)],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['shop_name'] ?? "",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff222f6d),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22)),
                              Text(data['shop_description'] ?? "",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xff222f6d),
                                    fontWeight: FontWeight.w500,
                                  )),
                              Text(data['full_name'] ?? "",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xff222f6d),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18)),
                              Text(data['address'] ?? "",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xff222f6d),
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              if (widget.requirment == null)
                                Container(
                                  height: 50,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data['services'].length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                            elevation: 3,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    '${data['services'][index]}'),
                                              ),
                                            ));
                                      }),
                                ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     GestureDetector(
                              //         onTap: () {
                              //           launch("tel://+${document.id}");
                              //         },
                              //         child: Icon(
                              //           Icons.call_rounded,
                              //           size: 25,
                              //           color: CupertinoColors.secondaryLabel,
                              //         )),
                              //     if (widget.requirment != null)
                              //       RaisedButton(
                              //           color: Colors.green,
                              //           onPressed: () async {
                              //             List<dynamic> bookings = [];

                              //             CollectionReference agents =
                              //                 FirebaseFirestore.instance
                              //                     .collection('agents');

                              //             await agents
                              //                 .doc('${document.id}')
                              //                 .get()
                              //                 .then((value) => bookings =
                              //                     value.get('bookings'));

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

                              //             agents.doc(document.id).update({
                              //               'bookings': bookings
                              //             }).then((value) {
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
                              //             style: GoogleFonts.poppins(
                              //                 color: Colors.white),
                              //           ))
                              //   ],
                              // )
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
