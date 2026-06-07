

import 'package:finance_app/models/bill_model.dart';
import 'package:finance_app/models/expense_category_extension.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/models/income_model.dart';
import 'package:finance_app/services/Income_service.dart';
import 'package:finance_app/services/bill_service.dart';
import 'package:finance_app/services/expense_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class TransactionsPage extends StatefulWidget
{
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
{
  List<ExpenseModel> expenses = [];
  List<IncomeModel> incomes = [];
  List<BillModel> bills = [];
  bool _loading = false;
  var logger = Logger();

  @override
  void initState()
  {
    super.initState();
    loadData();
  }

  Future<void> loadData() async
  {
    if (_loading == true) return;

    setState(()
    {
      _loading = true;
    });

    try
    {
      final exp = await ExpenseService().getAllExpense();
      final inc = await IncomeService().getAllIncome();
      final bill = await BillService().getListThisMonthBills();


      setState(()
      {
        incomes = inc;
        expenses = exp;
        bills = bill;
      });
    }
    catch (e)
    {
      logger.e("Veri yükleme hatası: $e");
    }
    finally
    {
      if(mounted)
      {
        setState(()
        {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    if (_loading)
    {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
                "Ödenecekler",
                style: TextStyle(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold),
              ),

              const SizedBox(height:16),

              ...bills.map((bill)
              {
                return billCard(bill);
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

          title: Row(
            children: [
              Expanded(
                child: Text(
                  income.title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  DateFormat('dd/MM/yyyy').format(income.transactionDate),
                  style: TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  "₺${income.amount}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.green,

                  fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget billCard(BillModel bill)
  {
    return Dismissible(
      key: Key(bill.id.toString()),
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
          incomes.removeWhere((element) => element.id == bill.id);
        });
        try
        {
          await IncomeService().deleteIncome(bill.id);
        }
        catch (e)
        {
          logger.e("Silme hatası: $e");
          loadData();
        }
      },
      child: Card(
        child: ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.green),

            title: Row(
              children: [
                Expanded(
                  child: Text(
                    bill.title,
                    style: TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                      "Son Ödeme Tarihi",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        DateFormat('dd/MM/yyyy').format(bill.finalPaymentDate),
                        style: TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    "₺${bill.amount}",
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.red,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
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

          title: Row(
            children: [
              Expanded(
                 child:Text(
                   expense.title,
                   style: TextStyle(fontWeight: FontWeight.w500),
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 )
              ),
              Expanded(
                child: Text(
                  DateFormat('dd/MM/yyyy').format(expense.transactionDate),
                  style: TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

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

