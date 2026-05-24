import 'dart:convert';

class TransactionModel
{
  final String title;
  final double amount;
  final String category;
  final String type;
  final DateTime date;

  TransactionModel (
  {
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String,dynamic> json)
  {
    return TransactionModel(
    title: json["title"],
    amount: (json["amount"] as num)?.toDouble() ?? 0.0,
    category: json["category"],
    type: json["type"],
    date: json["transactionDate"] != null ? DateTime.parse(json["transactionDate"]) :DateTime.now(),
  );
  }
}