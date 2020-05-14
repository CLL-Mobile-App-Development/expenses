import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_expense_tracker/widgets/expensechartbar.dart';


class ExpenseChart extends StatelessWidget {
  // Will be evolved in near future to connect to a database(firebase) or local storage to extract stored data.
  final List<DocumentSnapshot>
      expenseDataList; // List of expense item entries stored in the firestore collection:"expenses"

  ExpenseChart({@required this.expenseDataList});

  // Getter method to compute the total expense amount for each day in the past week
  List<Map<String, Object>> get dayToDayTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalAmount = 0.0;

      for (var expenseData in expenseDataList) {
        if (weekDay.year ==
                DateTime.parse(expenseData['transaction date']).year &&
            weekDay.month ==
                DateTime.parse(expenseData['transaction date']).month &&
            weekDay.day == DateTime.parse(expenseData['transaction date']).day)
          totalAmount += expenseData['expense amount'];
      }

      return {
        // Map
        'day': DateFormat.E().format(weekDay).substring(0,
            2), // converts integer weekday to a string format: 'Monday', 'Tuesday', ...
        'amount': totalAmount
      };
    });
  }

  // Getter method to compute the total expense amount
  double get totalExpenseAmount {
    return dayToDayTransactionValues.fold(0.0, (sum, expenseData) {
      return sum += expenseData['amount'];
    });
  }

  Widget build(BuildContext context) {
    print(dayToDayTransactionValues);
    print(totalExpenseAmount);
    return Container(
      child: Card(
        child: Padding(
          child: Row(
            children: dayToDayTransactionValues
                .map((expenseDataMap) {
                  return Flexible(
                    fit: FlexFit.tight,
                    child:
                   ExpenseChartBar(
                    barLabel: expenseDataMap['day'],
                    expAmount: expenseDataMap['amount'],
                    fractionOfTotalExpense: totalExpenseAmount == 0.0
                        ? 0.0
                        : (expenseDataMap['amount'] as double) /
                            totalExpenseAmount, // Check if totalExpenseAmount is 0.0 to avoid divide by zero operation and just pass 0.0 instead.
                    ),
                  );
                })
                .toList()
                .reversed
                .toList(), // Arranges bars in the ascending order of time, with today's expenses as the last bar to the right
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          padding: EdgeInsets.all(10.0),
        ),
        elevation: 10,
        margin: EdgeInsets.all(8.0),
      ),
      padding: EdgeInsets.all(4.0),
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.all(10.0),
    );
  }
}
