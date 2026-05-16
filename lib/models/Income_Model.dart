class CreateIncomeRequest
{
  final String title;
  final double amount;
  final DateTime transactionDate;

  CreateIncomeRequest({required this.title,required this.amount, required this.transactionDate});

  Map<String, dynamic> toJson()
  {
    return
        {
          "title" : title,
          "amount" : amount,
          "transactionDate" :transactionDate.toIso8601String(),
        };
  }
}