import 'package:flutter/material.dart';

class ExpenseChartAndListItems extends StatelessWidget {
  final bool displayChartBar;
  final AsyncSnapshot<dynamic> expenseSnapshot;
  final AppBar applBar;
  final Function deleteItemAction, updateItemAction, expenseChartBuilder, expenseItemListBuilder;

  ExpenseChartAndListItems({
    @required this.displayChartBar,
    @required this.expenseSnapshot,
    @required this.applBar,
    @required this.deleteItemAction,
    @required this.updateItemAction,
    @required this.expenseChartBuilder,
    @required this.expenseItemListBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Tertiary operator to toggle between expense chart and expense list view widgets, based on value set to _showChartBar.
        displayChartBar
            ? expenseChartBuilder(expenseSnapshot)
            : expenseItemListBuilder(expenseSnapshot, applBar, deleteItemAction, updateItemAction)
      ],
    );
  }
}
