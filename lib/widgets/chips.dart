import 'package:flutter/material.dart';

class CustomChips extends StatefulWidget {
  final title;
  CustomChips({Key key, this.title}) : super(key: key);

  @override
  CustomChipsState createState() => CustomChipsState();
}

class CustomChipsState extends State<CustomChips> {
  bool isClicked = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked == true ? isClicked = false : isClicked = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isClicked == false ? null : Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            width: 0.5,
            color: Colors.black,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                color: isClicked == false ? null : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
