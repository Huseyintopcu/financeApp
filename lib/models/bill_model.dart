class BillModel
{
  final int id;
  final String title;
  final double amount;
  final DateTime finalPaymentDate;

  BillModel(
  {
    required this.id,
    required this.title,
    required this.amount,
    required this.finalPaymentDate,
  });

  factory BillModel.fromJson(Map<String,dynamic> json)
  {
    return BillModel(
      id: json["id"],
      title: json["title"],
      amount: (json["amount"] as num).toDouble(),
      finalPaymentDate: DateTime.parse(json["finalPaymentDate"])
    );
  }
}