import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateExpenseItem extends StatefulWidget {
  // Converted to StatefulWidget to retain text on the bottom sheet even after completion
  // of typing through digital keypad and also after adding the expense item to the
  // scrollable list.
  // Short cut for code refactoring/formatting: Ctrl+Shift+R
  // (use ',' in the end of arg list for automatic code formatting)
  final DocumentSnapshot expenseItemDocument;
  final Function updateExpItemEventAction;

  UpdateExpenseItem({
    @required this.expenseItemDocument,
    @required this.updateExpItemEventAction,
  });

  @override
  _UpdateExpenseItemState createState() => _UpdateExpenseItemState();
}

class _UpdateExpenseItemState extends State<UpdateExpenseItem> {
  final _expenseNameController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  var _userPickedDate;
  
  void _updateItemEventActionWrapper() {
    final expName = _expenseNameController.text;
    final expAmtStr = _expenseAmountController.text;

    // Check for some value entry in the fields
    if (expName.isEmpty || expAmtStr.isEmpty || _userPickedDate == null) {
      return;
    }

    final expAmt = double.parse(expAmtStr);

    // Check for converted value
    if (expAmt <= 0) return;

    widget.updateExpItemEventAction(
      expName,
      expAmt,
      _userPickedDate,
      widget.expenseItemDocument['transactionId'],
    ); // Attributes of Widget class are accessible in the corresponding State class
    // through "widget" keyword.
    Navigator.of(context)
        .pop(); // To automatically close the bottom sheet after typing in the two fields.
    // Navigator tracks a widget state (so, probably used in a state class of a stateful widget ?) in a
    // stack and its state on the UI can be managed with stack operations like, push, pop.
    // It is a Stateful widget itself (maintains widget tree in a stack) with the "of" method to fetch the
    // current stored state that is part of the widget "context" (created/maintained by flutter). Here, as
    // our goal is to automatically close the bottom sheet, pop() operation is being performed on the retrieved
    // state.
    // ****Also, needs to be in the method that is tied to the FlatButton click enabling the add operation.
  }

  void _popUpDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.expenseItemDocument['transaction date']),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((userChosenDate) {
      if (userChosenDate == null) return;
      // else
      setState(() {
        _userPickedDate = userChosenDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    // Initialize the field values in the bottom modal sheet to be rendered with the edit icon button click.
    // Checks in place to retain all the field values when the widget is rebuilt with change in the user picked date.
    _userPickedDate = _userPickedDate == null ? DateTime.parse(widget.expenseItemDocument['transaction date']) : _userPickedDate;
    _expenseNameController.text = _expenseNameController.text.isEmpty ? widget.expenseItemDocument['expense name'] : _expenseNameController.text;
    _expenseAmountController.text = _expenseAmountController.text.isEmpty ? widget.expenseItemDocument['expense amount'].toString() : _expenseAmountController.text;

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  "Update Expense",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.button.color,
                    fontSize: 15,
                  ),
                ),
                color: Theme.of(context).primaryColor,
                onPressed:
                    _updateItemEventActionWrapper, // Flutter implicitly calls this wrapper method on button press.
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Expense Name",
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                controller: _expenseNameController,
                //onSubmitted: (_) => _updateItemEventActionWrapper(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Expense Amount",
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                controller: _expenseAmountController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      _userPickedDate == null
                          ? 'No date chosen !'
                          : 'Chosen Date: ${DateFormat.yMd().format(_userPickedDate)}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: _popUpDatePicker,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
