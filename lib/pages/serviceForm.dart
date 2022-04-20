// import 'dart:io';
// import 'dart:math';

// import 'package:customer/location.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../configView.dart';
// // import 'package:upi_pay/upi_pay.dart';

// class ServiceForm extends StatefulWidget {
//   final category;
//   const ServiceForm({Key key, this.category}) : super(key: key);

//   @override
//   _ServiceFormState createState() => _ServiceFormState();
// }

// class _ServiceFormState extends State<ServiceForm> {
//   String _upiAddrError;

//   final _upiAddressController = TextEditingController();
//   final _amountController = TextEditingController();

//   bool _isUpiEditable = false;
//   List<ApplicationMeta> _apps;

//   @override
//   void initState() {
//     super.initState();

//     _amountController.text =
//         (Random.secure().nextDouble() * 10).toStringAsFixed(2);

//   //   Future.delayed(Duration(milliseconds: 0), () async {
//   //     _apps = await UpiPay.getInstalledUpiApplications(
//   //         statusType: UpiApplicationDiscoveryAppStatusType.all);
//   //     setState(() {});
//   //   });
//   // }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _upiAddressController.dispose();
//     super.dispose();
//   }

//   void _generateAmount() {
//     setState(() {
//       _amountController.text =
//           (Random.secure().nextDouble() * 10).toStringAsFixed(2);
//     });
//   }

//   // Future<void> _onTap(ApplicationMeta app) async {
//   //   final err = _validateUpiAddress(_upiAddressController.text);
//   //   if (err != null) {
//   //     setState(() {
//   //       _upiAddrError = err;
//   //     });
//   //     return;
//   //   }
//   //   setState(() {
//   //     _upiAddrError = null;
//   //   });

//     // final transactionRef = Random.secure().nextInt(1 << 32).toString();
//   //   print("Starting transaction with id $transactionRef");

//   //   final a = await UpiPay.initiateTransaction(
//   //     amount: _amountController.text,
//   //     app: app.upiApplication,
//   //     receiverName: 'Sharad',
//   //     receiverUpiAddress: _upiAddressController.text,
//   //     transactionRef: transactionRef,
//   //     transactionNote: 'UPI Payment',
//   //     // merchantCode: '7372',
//   //   );

//   //   print(a);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController title = TextEditingController();
//     return Scaffold(
//       backgroundColor: isDarkMode ? darkMode : mainColor,
//       appBar: AppBar(
//         actionsIconTheme: IconThemeData(color: Colors.black),
//         title: Text(
//           'Describe you work',
//           style: isDarkMode
//               ? darkheading
//               : GoogleFonts.poppins(color: Colors.black),
//         ),
//         // backgroundColor: isDarkMode ? darkMode : mainColor,
//         // elevation: 0,
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         child: ListView(
//           children: <Widget>[
//             _vpa(),
//             if (_upiAddrError != null) _vpaError(),
//             _amount(),
//             if (Platform.isIOS) _submitButton(),
//             Platform.isAndroid ? _androidApps() : _iosApps(),
//           ],
//         ),
//       ),
//       // body: SingleChildScrollView(
//       //   child: Padding(
//       //     padding: EdgeInsets.symmetric(horizontal: 20),
//       //     child: Column(
//       //       crossAxisAlignment: CrossAxisAlignment.start,
//       //       children: [
//       //         TextFormField(
//       //           cursorColor: Colors.black,
//       //           decoration: new InputDecoration(
//       //               border: InputBorder.none,
//       //               focusedBorder: InputBorder.none,
//       //               // enabledBorder: InputBorder.none,
//       //               errorBorder: InputBorder.none,
//       //               disabledBorder: InputBorder.none,
//       //               contentPadding: EdgeInsets.only(
//       //                   left: 15, bottom: 11, top: 11, right: 15),
//       //               hintText: "Title"),
//       //         ),
//       //         Divider(
//       //           thickness: 2,
//       //         ),
//       //         TextFormField(
//       //           cursorColor: Colors.black,
//       //           decoration: new InputDecoration(
//       //               border: InputBorder.none,
//       //               focusedBorder: InputBorder.none,
//       //               // enabledBorder: InputBorder.none,
//       //               errorBorder: InputBorder.none,
//       //               disabledBorder: InputBorder.none,
//       //               contentPadding: EdgeInsets.only(
//       //                   left: 15, bottom: 11, top: 11, right: 15),
//       //               hintText: "Describe"),
//       //         ),
//       //         Divider(),
//       //         CupertinoButton(
//       //           onPressed: () {
//       //             launchMapsUrl(latitude, longitude);
//       //           },
//       //           child: Text('Conform your location'),
//       //         ),

//       //         Center(
//       //           child: CupertinoButton(
//       //               color: CupertinoColors.black,
//       //               child: Text('Next'),
//       //               onPressed: () {}),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     );
//   }

//   Widget _vpa() {
//     return Container(
//       margin: EdgeInsets.only(top: 32),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: TextFormField(
//               controller: _upiAddressController,
//               enabled: _isUpiEditable,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'address@upi',
//                 labelText: 'Receiving UPI Address',
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 8),
//             child: IconButton(
//               icon: Icon(
//                 _isUpiEditable ? Icons.check : Icons.edit,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isUpiEditable = !_isUpiEditable;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _vpaError() {
//     return Container(
//       margin: EdgeInsets.only(top: 4, left: 12),
//       child: Text(
//         _upiAddrError,
//         style: TextStyle(color: Colors.red),
//       ),
//     );
//   }

//   Widget _amount() {
//     return Container(
//       margin: EdgeInsets.only(top: 32),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: TextField(
//               controller: _amountController,
//               readOnly: true,
//               enabled: false,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Amount',
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 8),
//             child: IconButton(
//               icon: Icon(Icons.loop),
//               onPressed: _generateAmount,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _submitButton() {
//     return Container(
//       margin: EdgeInsets.only(top: 32),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: MaterialButton(
//               onPressed: () async => await _onTap(_apps[0]),
//               child: Text('Initiate Transaction',
//                   style: Theme.of(context)
//                       .textTheme
//                       .button
//                       .copyWith(color: Colors.white)),
//               color: Theme.of(context).accentColor,
//               height: 48,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _androidApps() {
//     return Container(
//       margin: EdgeInsets.only(top: 32, bottom: 32),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.only(bottom: 12),
//             child: Text(
//               'Pay Using',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//           ),
//           if (_apps != null) _appsGrid(_apps.map((e) => e).toList()),
//         ],
//       ),
//     );
//   }

//   Widget _iosApps() {
//     return Container(
//       margin: EdgeInsets.only(top: 32, bottom: 32),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.only(bottom: 24),
//             child: Text(
//               'One of these will be invoked automatically by your phone to '
//               'make a payment',
//               style: Theme.of(context).textTheme.bodyText2,
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(bottom: 12),
//             child: Text(
//               'Detected Installed Apps',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//           ),
//           if (_apps != null) _discoverableAppsGrid(),
//           Container(
//             margin: EdgeInsets.only(top: 12, bottom: 12),
//             child: Text(
//               'Other Supported Apps (Cannot detect)',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//           ),
//           if (_apps != null) _nonDiscoverableAppsGrid(),
//         ],
//       ),
//     );
//   }

//   GridView _discoverableAppsGrid() {
//     List<ApplicationMeta> metaList = [];
//     _apps.forEach((e) {
//       if (e.upiApplication.discoveryCustomScheme != null) {
//         metaList.add(e);
//       }
//     });
//     return _appsGrid(metaList);
//   }

//   GridView _nonDiscoverableAppsGrid() {
//     List<ApplicationMeta> metaList = [];
//     _apps.forEach((e) {
//       if (e.upiApplication.discoveryCustomScheme == null) {
//         metaList.add(e);
//       }
//     });
//     return _appsGrid(metaList);
//   }

//   GridView _appsGrid(List<ApplicationMeta> apps) {
//     apps.sort((a, b) => a.upiApplication
//         .getAppName()
//         .toLowerCase()
//         .compareTo(b.upiApplication.getAppName().toLowerCase()));
//     return GridView.count(
//       crossAxisCount: 4,
//       shrinkWrap: true,
//       mainAxisSpacing: 4,
//       crossAxisSpacing: 4,
//       // childAspectRatio: 1.6,
//       physics: NeverScrollableScrollPhysics(),
//       children: apps
//           .map(
//             (it) => Material(
//               key: ObjectKey(it.upiApplication),
//               // color: Colors.grey[200],
//               child: InkWell(
//                 onTap: Platform.isAndroid ? () async => await _onTap(it) : null,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     it.iconImage(48),
//                     Container(
//                       margin: EdgeInsets.only(top: 4),
//                       alignment: Alignment.center,
//                       child: Text(
//                         it.upiApplication.getAppName(),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }
// }

// String _validateUpiAddress(String value) {
//   if (value.isEmpty) {
//     return 'UPI VPA is required.';
//   }
//   if (value.split('@').length != 2) {
//     return 'Invalid UPI VPA';
//   }
//   return null;
// }
