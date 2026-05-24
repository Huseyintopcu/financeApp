import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:finance_app/pages/addExpense_page.dart';
import 'package:finance_app/pages/addIncome_page.dart';
import 'package:finance_app/pages/settings_page.dart';
import 'package:finance_app/services/Income_service.dart';
import 'package:finance_app/services/expense_service.dart';
import 'package:finance_app/services/transaction_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/transaction_model.dart';

class MainPage extends StatefulWidget
{
  const  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage>
{

  int _selectedIndex = 0;

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Pages
  final List<Widget> _pages =
  [
    const HomeDashboard(),
    const Center(child: Text("İşlemler Sayfası")),
    const Center(child: Text("Analiz Sayfası")),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlueAccent,

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,


        items: const
        [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "İşlemler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Analiz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Ayarlar",
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget
{
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
{
  double savingTarget=10;
  double income = 0;
  double expense = 0;
  double balance = 0;
  List<TransactionModel> transactions = [];
  bool _loading = false;

  @override
  void initState()
  {
    super.initState();
    loadData();
  }


  // Monthly total expense function
  Future<void> loadData() async
  {
    if (_loading == true) return;

    _loading = true;

    final inc = await IncomeService().getMonthlyIncome();
    final exp = await ExpenseService().getMonthlyExpense();
    final tran = await TransactionService().getTodayTransactions();

    if (!mounted) return;

    setState(()
    {
      transactions =tran;
      income = inc;
      expense = exp;
      print(expense);
      balance= income - expense;
    });
    print(transactions);
    _loading = false;
  }

  String getCategoryText(String? category)
  {
    switch (category)
    {
      case 'FOOD': return 'Yemek';
      case 'SNACKS': return 'Atıştırmalık';
      case 'HEALTH': return 'Sağlık';
      case 'BILLS': return 'Faturalar';
      case 'SHOPPİNG': return 'Alışveriş';
      case 'EDUCATION': return 'Eğitim';
      case 'TRANSPORT': return 'Ulaşım';
      case 'ENTERTAINMENT': return 'Eğlence';
      default: return 'Diğer';
    }
  }

  double getCategoryPercentage (String categoryName)
  {
    if (transactions.isEmpty || expense == 0) return 0;

    double todayTotalExpense = transactions
        .where((t) => t.type == "EXPENSE")
        .fold(0.0, (sum, t) => sum + t.amount);

    double categoryTotal = transactions
      .where((t) => t.type == "EXPENSE" && t.category == categoryName)
      .fold(0.0, (sum,t) => sum +t.amount);

    return (categoryTotal / todayTotalExpense) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finans Dashboard"),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              SizedBox(
                width: double.infinity,
                height: 110,
                child: Card(
                  color: Colors.blue.shade100,
                  child: Padding(
                    padding:const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                            "Kalan Bakiye",
                            style: TextStyle(fontSize: 16,color: Colors.orange)
                        ),
                        SizedBox(height: 8),
                        Text(
                          "₺${balance.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                [
                  // Income Card
                  Expanded(
                    child: SizedBox(
                      height: 110,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children:  [
                              Text(
                                  "Toplam Gelir",
                                  style: TextStyle(fontSize: 16)
                              ),
                              SizedBox(height: 8),
                              AutoSizeText(
                                  "₺$income",
                                  maxLines: 1,
                                  minFontSize: 8,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                  ),

                  // Savings Target Card
                  Expanded(
                      child:Card(
                        child:SizedBox(
                          height: 105,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  "Tassaruf Hedefi",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                AutoSizeText(
                                  "₺$savingTarget",
                                  maxLines: 1,
                                  minFontSize: 8,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      )

                  )
                ]
              ),


              const SizedBox(height: 20),

              // Daily spend limit
              const Text("Günlük Harcama Limiti"),

              const SizedBox(height: 8),

              LinearProgressIndicator(value: 0.3),

              const SizedBox(height: 20),

              // Fast Transactions
              const Text("Hızlı İşlemler"),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  ElevatedButton(
                    onPressed: () async
                    {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddIncomePage()),
                      );

                      if (result == true)
                        {
                          loadData();
                        }
                    },
                    child: const Text("+ Gelir"),
                  ),

                  ElevatedButton(
                    onPressed: () async
                    {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> const AddExpensePage()),
                      );

                      if (result == true)
                        {
                          loadData();
                        }
                    },
                    child: const Text("+ Gider"),
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("📷 Fiş"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Spend Pie Card
              const Text("Günlük Harcama Dağılımı"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 230,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                        sections: [
                          PieChartSectionData(
                            value: getCategoryPercentage("FOOD"),
                            title: "${getCategoryPercentage("FOOD").toStringAsFixed(0)}%",
                            showTitle: getCategoryPercentage("FOOD") > 0,
                            radius: 100,
                            color: Colors.orange,
                          ),
                          PieChartSectionData(
                            value: getCategoryPercentage("SNACKS"),
                            title: "${getCategoryPercentage("SNACKS").toStringAsFixed(0)}%",
                            radius: 100,
                            showTitle: getCategoryPercentage("SNACKS") > 0,
                            color: Colors.brown,
                          ),
                          PieChartSectionData(
                            value: getCategoryPercentage("TRANSPORT"),
                            title: "${getCategoryPercentage("TRANSPORT").toStringAsFixed(0)}%",
                            showTitle: getCategoryPercentage("TRANSPORT") > 0,
                            radius: 100,
                            color: Colors.blue,
                          ),
                          PieChartSectionData(
                            value: getCategoryPercentage("HEALTH"),
                            title: "${getCategoryPercentage("HEALTH").toStringAsFixed(0)}%",
                            showTitle: getCategoryPercentage("HEALTH") > 0,
                            radius: 100,
                            color: Colors.red,
                          ),
                          PieChartSectionData(
                            value: getCategoryPercentage("BILLS"),
                            title: "${getCategoryPercentage("BILLS").toStringAsFixed(0)}%",
                            showTitle: getCategoryPercentage("BILLS") > 0,
                            radius: 100,
                            color: Colors.purple,
                          ),
                          PieChartSectionData(
                            value: getCategoryPercentage("ENTERTAINMENT"),
                            title: "${getCategoryPercentage("ENTERTAINMENT").toStringAsFixed(0)}%",
                            showTitle: getCategoryPercentage("ENTERTAINMENT") > 0,
                            radius: 100,
                            color: Colors.pink,
                          ),
                          PieChartSectionData(
                            value: getCategoryPercentage("SHOPPING"),
                            title: "${getCategoryPercentage("SHOPPING").toStringAsFixed(0)}%",
                            showTitle: getCategoryPercentage("SHOPPING") > 0,
                            radius: 100,
                            color: Colors.green,
                          ),
                          PieChartSectionData(
                            value: getCategoryPercentage("EDUCATION"),
                            title: "${getCategoryPercentage("EDUCATION").toStringAsFixed(0)}%",
                            showTitle: getCategoryPercentage("EDUCATION") > 0,
                            radius: 100,
                            color: Colors.teal,
                          ),
                          PieChartSectionData(
                            value: getCategoryPercentage("OTHER"),
                            title: "${getCategoryPercentage("OTHER").toStringAsFixed(0)}%",
                            showTitle: getCategoryPercentage("OTHER") > 0,
                            radius: 100,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const
                        [
                          LegendItem(color: Colors.orange, text: "Yemek"),
                          LegendItem(color: Colors.brown, text: "Atıştırmalık"),
                          LegendItem(color: Colors.blue, text: "Ulaşım"),
                          LegendItem(color: Colors.red, text: "Sağlık"),
                          LegendItem(color: Colors.purple, text: "Faturalar"),
                          LegendItem(color: Colors.pink, text: "Eğlence"),
                          LegendItem(color: Colors.green, text: "Alışveriş"),
                          LegendItem(color: Colors.teal, text: "Eğitim"),
                          LegendItem(color: Colors.grey, text: "Diğer"),
                        ],
                      ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // Last Transactions
              const Text("Son İşlemler"),

              const SizedBox(height: 10),

              transactions.isEmpty ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Bugün bir işlem gerçekleştirmediniz",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              )
                : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context,index)
                {
                  final t = transactions[index];

                  return ListTile(
                    title: Row(
                      children:
                      [
                        Expanded(
                          flex: 4,
                          child: Text(t.title,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            t.type == "EXPENSE" ? "${getCategoryText(t.category)}" : "Gelir",
                            style: const TextStyle(color: Colors.orange),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            t.type == "EXPENSE" ? "-₺${t.amount}" : "+₺${t.amount}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: t.type == "EXPENSE" ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [

          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 8),

          Text(text),
        ],
      ),
    );
  }
}