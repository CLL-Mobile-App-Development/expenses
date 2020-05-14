// Standard Library
import 'package:flutter/material.dart';

// User-Defined
import 'expenseitem.dart';

class NonEmptyExpenseList extends StatelessWidget {
  
  final AsyncSnapshot<dynamic> expensesSnapshot;
  final Function deleteIconAction, updateIconAction;

  NonEmptyExpenseList({
    @required this.expensesSnapshot,
    @required this.deleteIconAction,
    @required this.updateIconAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: expensesSnapshot.data.documents.length,
        itemBuilder: (context, index) {
          return ExpenseItem(
            document: expensesSnapshot.data.documents[index],
            trashIconButtonAction: deleteIconAction,
            editIconButtonAction: updateIconAction,
          );
        },
        shrinkWrap: true,
        controller: ScrollController(
          initialScrollOffset: 0.0,
        ),
      ),
    );
  }
}
