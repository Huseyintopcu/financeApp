import 'package:finance_app/models/expense_category.dart';

class CreateExpenseRequest
{
  final String title;
  final double amount;
  final int quantity;
  final ExpenseCategory category;

  CreateExpenseRequest(
      {
        required this.title,
        required this.amount,
        required this.category,
        required this.quantity,
      }
  );

  Map<String, dynamic> toJson()
  {
    return
        {
          "title" : title,
          "amount" : amount,
          "category" : category.name,
          "quantity" : quantity,
        };
  }
}