import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:customer/pages/nearAgentContact.dart';
import 'package:customer/pages/viewbookings.dart';
import 'package:customer/widgets/appbar.dart';
import 'package:customer/widgets/textlogo.dart';
import 'package:customer/widgets/updatelocal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:customer/configView.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

/// This is the private State class that goes with Home.
class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String city;
  String name;
  String countryValue;
  String stateValue;
  String cityValue;

  Position currentPosition;

  List<String> tags = [];
  List<String> options = [];
  List<String> subserviceoptions = [];
  List<List<String>> allsubservice = [];
  List<String> subservicetitle = [];

  bool showitems = false;

  @override
  // ignore: override_on_non_overriding_member
  Future<void> getCurrentLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print(position);

      setState(() {
        currentPosition = position;
        longitude = position.longitude;
        latitude = position.latitude;
        updateCity(position.latitude, position.longitude);
      });
    }).catchError((e) {
      print(e);
    });
  }

  updateCity(x, y) async {
    final coordinates = new Coordinates(x, y);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.addressLine}");
    setState(() {
      city = first.addressLine;
      city = first.subAdminArea;
    });
  }

  getUserInfo() async {
    await FirebaseFirestore.instance
        .collection('customer')
        // .doc(auth.currentUser.phoneNumber)
        .doc(auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        print('Document data: ${documentSnapshot.data()}');
        setState(() {
          city = documentSnapshot.get('city');
          name = documentSnapshot.get('full_name');
          // point = documentSnapshot.get('cordinates');
        });
      }
    });
  }

  Future getservices() async {
    await FirebaseFirestore.instance
        .collection('services')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['name']);
        setState(() {
          options.add(doc['name']);
        });
      });
    });
    print("Options are: " + options.toString());
  }

  Future getSubService() async {
    print("Sub cat: ");
    await FirebaseFirestore.instance
        .collection('subservice')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<String> title = [];
      querySnapshot.docs.forEach((doc) {
        List<String> services = [];
        // print("Doc is  ${doc['name'][0]['name']}");
        title.add(doc.id.toString());

        for (var item in doc['name']) {
          services.add(item['name']);
        }
        setState(() {
          allsubservice.add(services);
        });

        // setState(() {
        //   subservices.add(Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       children: [
        //         Text(doc.id.toString()),
        //         Container(
        //           child: ChipsChoice<String>.multiple(
        //             value: tag,
        //             onChanged: (val) => setState(() => tag = val),
        //             choiceItems: C2Choice.listFrom<String, String>(
        //               source: chipTag,
        //               value: (i, v) => v,
        //               label: (i, v) => v,
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ));
        //     });
      });
      setState(() {
        subservicetitle = title;
      });
    });
    print("All title are: $subservicetitle");
    print("All title are: $allsubservice");

    // print("Options are: " + options.toString());
  }

  iscity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      city = prefs.getString('city');
    });
  }

  List<dynamic> images = [];
  getCarousel() async {
    CollectionReference carousel =
        FirebaseFirestore.instance.collection('carousel');

    await carousel.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        images.add(doc['url']);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    iscity();
    getCarousel();
    getSubService();
    getservices();
    tags = [];
  }

  @override
  Widget build(BuildContext context) {
    Widget imageCarousel = new Container(
        child: CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayCurve: Curves.easeInToLinear,
        enlargeCenterPage: true,
        viewportFraction: 2,
        aspectRatio: 2.0,
      ),
      items: images.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/background.png",
                      ),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: GestureDetector(
                    child: Image.network(i, fit: BoxFit.fill), onTap: () {}));
          },
        );
      }).toList(),
    ));
    return Scaffold(
      backgroundColor: Color(0xfff7f6f2),
      // bottomNavigationBar: Container(
      //   color: Color(0xff4361ee),
      //   child: Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         GestureDetector(
      //           onTap: () {
      //             if (auth.currentUser != null) {
      //               Navigator.push(
      //                   context,
      //                   PageTransition(
      //                       duration: Duration(milliseconds: 700),
      //                       type: PageTransitionType.leftToRight,
      //                       child: AgentNearMe(
      //                         city: city,
      //                       )));
      //             } else {
      //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //                 content: Text(
      //                     "Account not create. Book Something to create account"),
      //               ));
      //             }
      //           },
      //           child: Icon(Icons.phone_in_talk_rounded,
      //               size: 30, color: Colors.white),
      //         ),
      //         GestureDetector(
      //           onTap: () {
      //             Navigator.push(
      //                 context,
      //                 PageTransition(
      //                     duration: Duration(milliseconds: 600),
      //                     type: PageTransitionType.bottomToTop,
      //                     child: Cart(items: tags)));
      //           },
      //           child: Icon(Icons.add_circle_outline_sharp,
      //               size: 30, color: Colors.white),
      //         ),
      //         GestureDetector(
      //           onTap: () {
      //             // child: ShowWeb()));
      //           },
      //           child: Icon(Icons.history, size: 30, color: Colors.white),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.only(top: 50),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextLogo(),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.book, color: Colors.orange),
                  SizedBox(width: 10),
                  Text(
                    'Your Booking',
                    style: heading,
                  )
                ],
              ),
              onTap: () {
                if (auth.currentUser != null) {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 600),
                          type: PageTransitionType.bottomToTop,
                          child: ViewBooking(
                            city: city,
                          )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Account not create. Book Something to create account"),
                  ));
                }
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.store, color: Colors.orange),
                  SizedBox(width: 10),
                  Text(
                    'Near Shops',
                    style: heading,
                  )
                ],
              ),
              onTap: () {
                if (auth.currentUser != null) {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 700),
                          type: PageTransitionType.leftToRight,
                          child: AgentNearMe(
                            city: city,
                          )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Account not create. Book Something to create account"),
                  ));
                }
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.store, color: Colors.orange),
                  SizedBox(width: 10),
                  Text(
                    'Update Location',
                    style: heading,
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                                body: SafeArea(
                              child: UpdateLocal(),
                            ))));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.feedback_rounded, color: Colors.orange),
                  SizedBox(width: 10),
                  Text(
                    'Feedback',
                    style: heading,
                  )
                ],
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(500), child: CustomAppBar()),
      body: city != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    imageCarousel,
                    if (imageCarousel == null)
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: true,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: 6,
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF3366FF).withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Mix Services',
                                  style: GoogleFonts.poppins(
                                      color: CupertinoColors.secondaryLabel,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showitems
                                          ? showitems = false
                                          : showitems = true;
                                    });
                                  },
                                  icon: showitems
                                      ? Icon(Icons.keyboard_arrow_up_outlined)
                                      : Icon(
                                          Icons.keyboard_arrow_down_outlined))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showitems,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          // color: Color(0xff3d405b),
                          borderRadius: BorderRadius.circular(6),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black38,
                          //     blurRadius: 3.0,
                          //   )
                          // ],
                          // gradient: LinearGradient(
                          //   colors: [Color(0xffb6ccfe), Color(0xffe2eafc)],
                          // ),
                        ),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AgentNearMe(
                                                city: city,
                                                requirment: options[index],
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Chip(
                                      backgroundColor: Colors.white,
                                      label: Text(options[index])),
                                ),
                              );
                            }),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   child: SingleChildScrollView(
                    //     child: Center(
                    //       child: ChipsChoice<String>.multiple(
                    //         choiceStyle: C2ChoiceStyle(
                    //           elevation: 2,
                    //           labelStyle: TextStyle(
                    //               fontWeight: FontWeight.w400, fontSize: 22),
                    //         ),
                    //         choiceActiveStyle: C2ChoiceStyle(
                    //           elevation: 0,
                    //           labelStyle: TextStyle(
                    //               color: Colors.green,
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 22),
                    //         ),
                    //         value: tags,
                    //         onChanged: (val) => setState(() => tags = val),
                    //         choiceItems: C2Choice.listFrom<String, String>(
                    //           source: options,
                    //           value: (i, v) => v,
                    //           label: (i, v) => v,
                    //         ),
                    //         direction: Axis.horizontal,
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    for (int i = 0; i < subservicetitle.length; i++)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFF3366FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(subservicetitle[i],
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  // color: Color(0xff3d405b),
                                  borderRadius: BorderRadius.circular(6),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.black38,
                                  //     blurRadius: 3.0,
                                  //   )
                                  // ],
                                  // gradient: LinearGradient(
                                  //   colors: [
                                  //     Color(0xffb6ccfe),
                                  //     Color(0xffe2eafc)
                                  //   ],
                                  // ),
                                ),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: allsubservice[i].length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AgentNearMe(
                                                        city: city,
                                                        requirment:
                                                            allsubservice[i]
                                                                [index],
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Chip(
                                              backgroundColor: Colors.white,
                                              label: Text(
                                                allsubservice[i][index],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )),
                                        ),
                                      );
                                    }),
                              )
                              // ChipsChoice<String>.multiple(
                              //   choiceStyle: C2ChoiceStyle(
                              //     elevation: 2,
                              //     labelStyle: TextStyle(
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 20),
                              //   ),
                              //   choiceActiveStyle: C2ChoiceStyle(
                              //     elevation: 0,
                              //     labelStyle: TextStyle(
                              //         color: Colors.green,
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 20),
                              //   ),
                              //   value: tags,
                              //   onChanged: (val) => setState(() => tags = val),
                              //   choiceItems: C2Choice.listFrom<String, String>(
                              //     source: allsubservice[i],
                              //     value: (i, v) => v,
                              //     label: (i, v) => v,
                              //   ),
                              //   direction: Axis.horizontal,
                              // )
                            ],
                          ),
                        ),
                      ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     color: isDarkMode ? darkCard : Color(0xfff8f8f8),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           Text(
                    //             'Share and get Discount.',
                    //             style: isDarkMode ? darkheading : heading,
                    //           ),
                    //           Text(
                    //             'Invite your friend if they make first Order You will get some coins and that can be used to get some discount on your next order.',
                    //             style: isDarkMode
                    //                 ? darkSecondaryText
                    //                 : secondaryText,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('I want my booking in',
                        style: GoogleFonts.lato(
                            fontSize: 28, fontWeight: FontWeight.w400)),
                  ),
                  Image.asset('assets/map_location.png'),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          CSCPicker(
                            onCountryChanged: (value) {
                              setState(() {
                                countryValue = value;
                              });
                            },
                            onStateChanged: (value) {
                              setState(() {
                                stateValue = value;
                              });
                            },
                            onCityChanged: (value) {
                              setState(() {
                                cityValue = value;
                              });
                            },
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoButton(
                        color: Colors.orange,
                        child: Text('Update'),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            prefs.setString('city', cityValue);
                          });
                          iscity();
                        }),
                  )
                ],
              ),
            ),
    );
  }
}
