class IncomeModel
{
  final int id;
  final String title;
  final double amount;
  final DateTime transactionDate;

  IncomeModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.transactionDate,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json)
  {
    return IncomeModel(
      id: json["id"],

      title: json["title"],

      amount: (json["amount"] as num).toDouble(),

      transactionDate: DateTime.parse(json["transactionDate"]),
    );
  }
}