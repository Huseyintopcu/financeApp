class CreateBillRequest
{
  final String title;
  final double amount;
  final DateTime finalPaymentDate;

  CreateBillRequest({required this.title, required this.amount, required this.finalPaymentDate});

  Map<String, dynamic> toJson()
  {
    return
    {
      "title" : title,
      "amount" : amount,
      "finalPaymentDate" : finalPaymentDate.toIso8601String()
    };
  }
}