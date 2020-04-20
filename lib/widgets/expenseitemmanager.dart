/* // Standard Libraries
import 'package:flutter/material.dart';

// User-Defined Libraries
import '../models/expenseitementry.dart';
import 'expenseitem.dart';

class ExpenseItemManager extends StatelessWidget {

  final List<ExpenseItemEntry> itemEntryList;
  ExpenseItemManager({@required this.itemEntryList}); // Passed in constructor argument is set to itemEntryList

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // Expense item list
        children: <Widget>[
          ...(itemEntryList.map((itemEntryInList) {
            // The ... in the front is to unpack the resultant list items (from .toList() in the end) to individual items, as part of the parent widget list and not a sub-list.
            // itemEntryInList is only in the scope of map() input argument
            return ExpenseItem(
              itemEntry: itemEntryInList,
            );
          }).toList()),
        ],
        //mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}
 */