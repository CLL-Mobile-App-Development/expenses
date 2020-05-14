import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/services.dart';

//import './widgets/expenseitemmanager.dart';

import './widgets/newexpenseitem.dart';
import './widgets/updateexpenseitem.dart';
import './widgets/scaffoldwithbottomsheet.dart';

void main() {
  runApp(PersonalExpenses());
}

class PersonalExpenses extends StatefulWidget {

  // Method to wire the user input from new expense item widget to the expense item list widget
  @override
  _PersonalExpensesState createState() => _PersonalExpensesState();
}

class _PersonalExpensesState extends State<PersonalExpenses> with WidgetsBindingObserver{

  void _addNewExpenseItem(String newExpenseName, double newExpenseAmt,
      DateTime userTransactionDate) {
    print("Item name: $newExpenseName, Expense Amount: $newExpenseAmt");

    Firestore.instance.collection('expenses').add({
      'expense name': newExpenseName,
      'expense amount': newExpenseAmt,
      'transaction date': /*DateTime.now().toString()*/ userTransactionDate
          .toString(),
      'transactionId': DateTime.now().toString(),
    });
  }

  void _updateChosenExpenseItem(
      String updatedExpenseName,
      double updatedExpenseAmt,
      DateTime updatedTransactionDate,
      String updateItemTransactionId) {
    Firestore.instance.collection('expenses').snapshots().forEach((qSnapshot) {
      qSnapshot.documents.forEach((dSnapshot) {
        if (dSnapshot['transactionId'] == updateItemTransactionId) {
          Firestore.instance
              .collection('expenses')
              .document(dSnapshot.documentID)
              .updateData({
            'expense name': updatedExpenseName,
            'expense amount': updatedExpenseAmt,
            'transaction date': updatedTransactionDate.toString(),
            'transactionId': DateTime.now().toString(),
          });
        }
      });
    });
  }

  void _deleteChosenExpenseItem(String deleteItemTransactionId) {
    print('Inside _deleteChosenExpenseItem');
    // Extract the id of matching document in the collection
    Firestore.instance.collection('expenses').snapshots().forEach((qsnapshot) {
      qsnapshot.documents.forEach((expenseDoc) {
        print('Exp doc id: ${expenseDoc.documentID}');
        if (expenseDoc['transactionId'] == deleteItemTransactionId) {
          print(
              'Found the item to be deleted with id : ${expenseDoc.documentID} !');
          Firestore.instance
              .collection('expenses')
              .document(expenseDoc.documentID)
              .delete();
        }
      });
    });
  }

  void _pullUpBottomModalSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: NewExpenseItem(newExpItemEventAction: _addNewExpenseItem),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
      useRootNavigator: true,
      elevation: 10,
    ); // The '_' ignores the input build context argument given by
    // showModalBottomSheet method itself.
  }

  void _updateWithBottomModalSheet(
      BuildContext ctx, DocumentSnapshot updateItem) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: UpdateExpenseItem(expenseItemDocument: updateItem,updateExpItemEventAction: _updateChosenExpenseItem,),
        );
      },
      useRootNavigator: true,
      elevation: 10,
    );
  }


  // initState() method executed when this widget is created
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // Callback for app cycle event listener/observer
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  // dispose() method executed when this widget is destroyed
  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this); // Essentially assigning this state widget as an observer 
                                                  // for the app lifecycle state change and accordingly take an action.
    super.dispose();
  }


  Widget build(BuildContext context) {
    return MaterialApp(
      // With the Scaffold widget holding the modal bottom sheet, there was an issue with MediaQuery widget not being available through the
      // ancestral context. So, split it up in to a separate widget. Other pieces of code seemd to be in place apart from the widget hierarchy
      // between MaterialApp (supposedly adds the MediaQuery widget) and Scaffold giving them different contexts.
      home: ScaffoldWithBottomSheet(
        // itemList: _itemEntryList,
        addWithBottomSheetAction: _pullUpBottomModalSheet,
        deleteWithTrashIconAction: _deleteChosenExpenseItem,
        updateWithBottomSheetAction: _updateWithBottomModalSheet,
        /* generateItemList: _generateExpenseItemList, */
      ),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Montserrat',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              button:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: ThemeData.dark()
                        .accentColor, // To be used for the text styling in the appBar of Scaffold widget
                  ),
                ),
            actionsIconTheme: IconThemeData(
                color: ThemeData.dark()
                    .accentColor) // To be used as the appBar actions button color
            ),
      ),
    ); // ThemeData settings are at the app-level.
    // Other widgets in the widget tree can use the app-level settings in a generic way.
    // That way, changes can only be done here in one place with widgets re-painted and
    // changes reflected automatically through out the application.
    // The .of(context) can be used to fetch the desired state, like Theme, Navigator etc.
    // and then another '.' notation to access respective attributes/properties.
    // accentColor setting to be used in combination with primarySwatch, as fallback color.
  }
}
