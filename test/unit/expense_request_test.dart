import 'package:finance_app/models/expense_category.dart';


class ExpenseModel
{
  final int id;
  final String title;
  final double amount;
  final int quantity;
  final ExpenseCategory category;
  final DateTime transactionDate;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.quantity,
    required this.category,
    required this.transactionDate,
  });

  factory ExpenseModel.fromJson(Map<String,dynamic> json)
  {
    return ExpenseModel(
      id: json["id"],

      title: json["title"],

      amount: (json["amount"] as num).toDouble(),

      quantity: json["quantity"],

      category: ExpenseCategory.values.firstWhere((e) => e.name == json["category"],),

      transactionDate: DateTime.parse(json["transactionDate"],),
    );
  }
}