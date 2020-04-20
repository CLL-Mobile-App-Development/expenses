import 'package:flutter/foundation.dart';

class ExpenseItemEntry{

  final int itemId;
  final String itemName;
  final double itemPrice;
  final DateTime purchaseDate;

ExpenseItemEntry({@required this.itemId, @required this.itemName, @required this.itemPrice, @required this.purchaseDate});

}