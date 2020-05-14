import 'package:flutter/material.dart';

class EmptyExpenseList extends StatelessWidget {
  final AppBar appBarWidget;

  EmptyExpenseList({@required this.appBarWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            "Waiting for your expense data...",
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20),
          ),
          height: (MediaQuery.of(context).size.height -
                  appBarWidget.preferredSize.height) *
              0.1,
        ),
        SizedBox(
          height: (MediaQuery.of(context).size.height -
                  appBarWidget.preferredSize.height) *
              0.05,
        ), // Adds space between widgets resulting in better layout
        Container(
          child: Image.asset(
            "assets/images/waiting.png",
          ),
          height: (MediaQuery.of(context).size.height -
                  appBarWidget.preferredSize.height) *
              0.6, // Now 60% of available viewport height, previously was set to fixed value of 300
        ),
      ],
    );
  }
}
