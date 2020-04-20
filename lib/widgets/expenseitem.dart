import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ExpenseItem extends StatefulWidget {
  /* final ExpenseItemEntry itemEntry;

  ExpenseItem({
    @required this.itemEntry,
  }); */

  /* final DocumentSnapshot document; */
  final DocumentSnapshot document;
  final Function trashIconButtonAction, editIconButtonAction;

  ExpenseItem({
    @required this.document,
    @required this.trashIconButtonAction,
    @required this.editIconButtonAction,
  });

  @override
  _ExpenseItemState createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {

  Color _bgColor;

  Widget _buildLeadingCircleAvatarWithExpenseAmt() {
    return CircleAvatar(
      backgroundColor: _bgColor,
      radius: 35,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: FittedBox(
          child: Text(
            '\$${widget.document['expense amount']}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWithExpenseName() {
    return Text(
      '${widget.document['expense name']}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Montserrat',
      ),
    );
  }

  Widget _buildSubTitleWithTransactionDate() {
    return Text(
      '${DateFormat.yMMMd().format(DateTime.parse(widget.document['transaction date']))}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: 'Montserrat',
      ),
    );
  }

  Widget _buildTextAndIconsInLandscapeMode(BuildContext landscapeContext) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.edit,
              color: Theme.of(landscapeContext).cursorColor,
            ),
            label: const Text('Edit'),
            onPressed: () {
              print(
                  'Viewport width: ${MediaQuery.of(landscapeContext).size.width}');
              widget.editIconButtonAction(landscapeContext, widget.document);
            },
          ),
          FlatButton.icon(
            icon: Icon(
              Icons.delete,
              color: Theme.of(landscapeContext).errorColor,
            ),
            label: const Text('Delete'),
            onPressed: () {
              print('transactionId: ${widget.document['transactionId']}');
              widget.trashIconButtonAction(widget.document['transactionId']);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJustIconsInPortraitMode(BuildContext portraitContext) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(portraitContext).cursorColor,
            ),
            onPressed: () {
              print(
                  'Viewport width: ${MediaQuery.of(portraitContext).size.width}');
              widget.editIconButtonAction(portraitContext, widget.document);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(portraitContext).errorColor,
            ),
            onPressed: () {
              print('transactionId: ${widget.document['transactionId']}');
              widget.trashIconButtonAction(widget.document['transactionId']);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super
        .initState(); // Called before any code in child for setup required prior to the start of child actions

    const randomColors = [
      Colors.blue,
      Colors.grey,
      Colors.green,
      Colors.lime,
    ];

    _bgColor = randomColors[Random().nextInt(4)]; // starts from 0 to 3, excluding the max 4.
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Card(
    //     child: Row(
    //       children: <Widget>[
    //         Container(
    //           child: Text(
    //             (/* "\$${itemEntry.itemPrice.toStringAsFixed(2)}" */ "\$" +
    //                 document['expense amount']
    //                     .toString()), // Fetched as input to ExpenseItem class constructor.
    //             style: /* TextStyle(
    //               color: Theme.of(context)
    //                   .primaryColor, // Fetches primaryColor from the primarySwatch color scheme set at app-level
    //               // in the "theme" attribute of MaterialApp widget.
    //               // The of(context) method fetches the Theme state that is part of the context.
    //               fontWeight: FontWeight.w400,
    //               fontSize: 20,
    //             ) */ Theme.of(context).textTheme.title.copyWith(
    //                       fontSize: 20,
    //                       color: Theme.of(context).primaryColor,
    //                     ),
    //           ),
    //           decoration: BoxDecoration(
    //               border: Border.all(
    //                   color: Theme.of(context).primaryColor, width: 2.5)),
    //           padding: EdgeInsets.all(14.0),
    //           margin: EdgeInsets.all(10.0),
    //         ),
    //         Container(
    //           child: Column(
    //             children: <Widget>[
    //               Text(
    //                 /* "${itemEntry.itemName}" */ document['expense name'],
    //                 style: Theme.of(context).textTheme.title.copyWith(
    //                       fontSize: 20,
    //                     ),
    //               ),
    //               Text(
    //                 DateFormat.yMMMd().format(
    //                     /* itemEntry.purchaseDate */ DateTime.parse(document[
    //                         'transaction date'])), // Convert TimeStamp -> String -> DateTime through parse
    //                 style: Theme.of(context).textTheme.title.copyWith(
    //                       color: Colors.grey,
    //                     ),
    //               )
    //             ],
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //           ),
    //         ),
    //       ],
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //     ),
    //     //color: Colors.grey,
    //     elevation: 10,
    //     margin: EdgeInsets.all(8.0),
    //   ),
    //   padding: EdgeInsets.all(4.0),
    //   width: double.infinity,
    //   height: 100,
    //   //decoration: BoxDecoration(border: Border.all(width: 4.0)),
    //   //alignment: Alignment(0.0,0.0),
    // )
    return Container(
      child: Card(
        child: ListTile(
          leading: _buildLeadingCircleAvatarWithExpenseAmt(),
          title: _buildTitleWithExpenseName(),
          subtitle: _buildSubTitleWithTransactionDate(),
          trailing: MediaQuery.of(context).size.width > 550
              ? _buildTextAndIconsInLandscapeMode(context)
              : _buildJustIconsInPortraitMode(context),
        ),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        elevation: 5,
      ),
      height: 100,
      alignment: Alignment.center,
      key: UniqueKey(),
    );
  }
}
