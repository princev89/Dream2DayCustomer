import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchAgent extends StatefulWidget {
  // final value;
  SearchAgent({Key key}) : super(key: key);

  @override
  _SearchAgentState createState() => _SearchAgentState();
}

class _SearchAgentState extends State<SearchAgent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          height: 0,
        ),
        actions: [CupertinoButton(child: Text('Search'), onPressed: () {})],
        title: Text('Seach'),
      ),
      body: Column(
        children: [
          CupertinoSearchTextField(
            onSubmitted: (value) {
              print(value);
            },
          )
        ],
      ),
    );
  }
}
