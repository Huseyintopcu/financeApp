import 'expense_category.dart';

class ApiModel
{
  final String title;
  final double amount;
  final int quantity;
  final ExpenseCategory category;

  ApiModel(
  {
    required this.title,
    required this.amount,
    required this.quantity,
    required this.category,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json)
  {
    return ApiModel(
      title: json["title"] ?? "",
      amount: (json["amount"] as num).toDouble(),
      quantity: json["quantity"] ?? 0,
      category: ExpenseCategory.values.firstWhere((e) => e.name == json["category"],),
    );
  }
}