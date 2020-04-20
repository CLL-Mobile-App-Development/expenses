import 'package:flutter/material.dart';

class ExpenseChartBar extends StatelessWidget {
  final String barLabel;
  final double expAmount, fractionOfTotalExpense;

  ExpenseChartBar({
    @required this.barLabel,
    @required this.expAmount,
    @required this.fractionOfTotalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight *
                  0.15, // 15% of max possible height derived from parent contraints
              child: FittedBox(
                child: Text(
                  '\$${expAmount.round()}',
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight *
                  0.05, // 5% of max possible height derived from parent contraints
            ),
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(220, 220, 220, 1),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: fractionOfTotalExpense,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              height: constraints.maxHeight * 0.6,
              width: constraints.minWidth * 0.18,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              child: Text(barLabel,),
              height: constraints.maxHeight * 0.15,
            ),
          ],
        );
      },
    );
  }
}
