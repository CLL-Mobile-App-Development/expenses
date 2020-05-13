// Standard Library
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// User-defined
import 'expensechart.dart';
import 'expensechartandlistitems.dart';
import 'emptyexpenselist.dart';
import 'nonemptyexpenselist.dart';

class ScaffoldWithBottomSheet extends StatefulWidget{
  // final List<ExpenseItemEntry> itemList;
  final Function addWithBottomSheetAction,
      deleteWithTrashIconAction, updateWithBottomSheetAction /* , generateItemList */;

  ScaffoldWithBottomSheet({
    // @required this.itemList,
    @required this.addWithBottomSheetAction,
    @required this.deleteWithTrashIconAction,
    @required this.updateWithBottomSheetAction,
    /* @required this.generateItemList */
  });

  @override
  _ScaffoldWithBottomSheetState createState() =>
      _ScaffoldWithBottomSheetState();
}

class _ScaffoldWithBottomSheetState extends State<ScaffoldWithBottomSheet>{
  bool _showChartBar = false; // For Switch widget to toggle between chart

  _chartListWidgetToggle(val) {
    setState(() {
      _showChartBar = val;
      print("_showChartBar is set to: $_showChartBar");
    });
  }

  List<DocumentSnapshot> _retrievelastWeekExpenses(
      AsyncSnapshot<dynamic> expSnapshot) {
    
    if(expSnapshot.hasData)
      return expSnapshot.data.documents.where((dSnapshot) {
        return DateTime.parse(dSnapshot['transaction date'])
            .isAfter(DateTime.now().subtract(Duration(days: 7)));
      }).toList();
    else // No data in the query snapshot fetched from the firestore collection: "expenses"
      return [];
    
  }

  // Build ExpenseChart widget inside a Container widget
  Widget buildExpenseChartInContainer(AsyncSnapshot<dynamic> qSnapshot) {

    return Container(
                //height: MediaQuery.of(context).size.height * 0.4,
                //width: MediaQuery.of(context).size.width * 0.7,
                child: ExpenseChart(
                  expenseDataList: _retrievelastWeekExpenses(qSnapshot),
                ),
                alignment: Alignment.center,
              ); // Pass in the document(expense entries in "expenses" collection of firestore) list to the chart widget,)
     }

  // Build expense item list
  Widget buildExpenseItemList(AsyncSnapshot<dynamic> qSnapshot, AppBar applicationBar, Function deleteAction, Function updateActionWithBottomSheet){
    return (!qSnapshot.hasData) ||
                    (qSnapshot.data.documents.length ==
                        0) // Condition to check if backend has no expense data
                ? EmptyExpenseList(
                    appBarWidget: applicationBar,
                  )
                : NonEmptyExpenseList(
                    expensesSnapshot: qSnapshot,
                    deleteIconAction: deleteAction,
                    updateIconAction: updateActionWithBottomSheet,
                  );
  }

  // Build landscape mode content
  List<Widget> _buildLandscapeContent(AsyncSnapshot<dynamic> snapshot, AppBar _appBar){
    return [Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Display Expense Chart',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Switch(
                          value: _showChartBar,
                          onChanged: _chartListWidgetToggle,
                        ),
                      ],
                    ), ExpenseChartAndListItems(
                      displayChartBar: _showChartBar,
                      expenseSnapshot: snapshot,
                      applBar: _appBar,
                      deleteItemAction: widget
                          .deleteWithTrashIconAction, // "widget." allows arguments in StatefulWidget class to be accessible in its corresponding state class.
                      updateItemAction: widget.updateWithBottomSheetAction,
                      expenseChartBuilder: buildExpenseChartInContainer,
                      expenseItemListBuilder: buildExpenseItemList,
                    ),];
  }

  // Build porttrait mode content
  List<Widget> _buildPortraitContent(AsyncSnapshot<dynamic> snapshot, AppBar _appBar){
    return [buildExpenseChartInContainer(snapshot), buildExpenseItemList(snapshot, _appBar, widget.deleteWithTrashIconAction, widget.updateWithBottomSheetAction,),];
  }


  @override
  Widget build(BuildContext context) {
    // Know the current device orientation
    Orientation currentAppOrientation = MediaQuery.of(context).orientation;

    // Declared outside the Scaffold widget to be used in other widgets for enabling dynamic sizing and thereby responsiveness
    final _appBar = AppBar(
      title: /* Theme.of(context).appBarTheme.textTheme.title, */ Text(
        "Personal Expenses",
        style: Theme.of(context).appBarTheme.textTheme.headline6,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
          onPressed: () => widget.addWithBottomSheetAction(context),
        ),
      ],
    );

     
    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: Firestore.instance.collection('expenses').snapshots(),
          builder: (context, snapshot) {
            return Container(
              child: Column(
                children: <Widget>[
                  // Switch to choose between expense chart or expense items to be displayed in the app when device is in landscape mode.
                  if (currentAppOrientation == Orientation.landscape)
                    ..._buildLandscapeContent(snapshot, _appBar), // The spread operator ("...") is used to unpack array elements in to its individual elements
                  
                  // Diplay expense chart and expense items when user sets device in portrait mode.
                  if (currentAppOrientation == Orientation.portrait)
                    ..._buildPortraitContent(snapshot, _appBar),  
                    
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.center,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => widget.addWithBottomSheetAction(context),
        backgroundColor: Color.fromRGBO(255, 255, 0, 0.7), // color with opacity for getting a transparent button, instead of using Opacity widget that deterrs performance.
      ),
    );
  }
}
