
import 'package:finance_app/models/expense_category_extension.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/models/income_model.dart';
import 'package:finance_app/services/Income_service.dart';
import 'package:finance_app/services/expense_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TransactionsPage extends StatefulWidget
{
  const TransactionsPage({super.key});

  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
{
  List<ExpenseModel> expenses = [];
  List<IncomeModel> incomes = [];
  var logger = Logger();

  @override
  void initState()
  {
    super.initState();
    loadData();
  }

  Future<void> loadData() async
  {
    final exp = await ExpenseService().getAllExpense();
    final inc = await IncomeService().getAllIncome();

    setState(() 
    {
      incomes = inc;
      expenses = exp;
      print("GELİRlER: $incomes.length");
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Gelirler",
                style: TextStyle(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold),
              ),

              const SizedBox(height:16),

              ...incomes.map((income)
              {
                return incomeCard(income);
              }),

              const SizedBox(height: 30),
              
              const Text(
                "Giderler",
                style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height:16),

              ...expenses.map((expense)
              {
                return expenseCard(expense);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget incomeCard(IncomeModel income)
  {
    return Dismissible(
        key: Key(income.id.toString()),
        direction: DismissDirection.endToStart,

        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 10),
          color: Colors.red,
          child: const Icon(Icons.delete,color: Colors.white,),
        ),

        onDismissed: (_) async
        {
         setState(()
         {
           incomes.removeWhere((element) => element.id == income.id);
         });
         try
         {
           await IncomeService().deleteIncome(income.id);
         }
         catch (e)
          {
            logger.e("Silme hatası: $e");
            loadData();
          }
        },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.arrow_upward, color: Colors.green),

          title: Text(income.title),

          trailing: Text(
            "₺${income.amount}",
            style: const TextStyle(color: Colors.green,
            fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget expenseCard(ExpenseModel expense)
  {
    return Dismissible(
      key: Key(expense.id.toString()),

      direction: DismissDirection.endToStart,

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete,color: Colors.white,),
      ),

      onDismissed: (_) async
      {
        setState(()
        {
          expenses.removeWhere((element) => element.id == expense.id);
        });

        try
        {
          await ExpenseService().deleteExpense(expense.id);
        }
        catch (e)
        {
          logger.e("Silme hatası: $e");
          loadData();
        }
      },

      child: Card(
        child: ListTile(
          leading: Icon(expense.category.icon, color: expense.category.color,),

          title: Text(expense.title),

          subtitle: Text(expense.category.trName),

          trailing: Text(
            "-₺${expense.amount}",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      )
    );
  }
}

