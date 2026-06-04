
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:finance_app/pages/addBill_page.dart';
import 'package:finance_app/pages/addExpense_page.dart';
import 'package:finance_app/pages/addIncome_page.dart';
import 'package:finance_app/pages/analysis_page.dart';
import 'package:finance_app/pages/settings_page.dart';
import 'package:finance_app/pages/transactions_page.dart';
import 'package:finance_app/services/Income_service.dart';
import 'package:finance_app/services/bill_ai_service.dart';
import 'package:finance_app/services/bill_service.dart';
import 'package:finance_app/services/expense_service.dart';
import 'package:finance_app/services/notification_service.dart';
import 'package:finance_app/services/transaction_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../core/network/api_client.dart';
import '../models/expense_model.dart';
import '../models/expense_request.dart';
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
    const TransactionsPage(),
    const AnalysisPage(),
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
  static Dio get _dio => ApiCLient.dio;

  double savingTarget =0.0;
  double income = 0.0;
  double expense = 0.0;
  double balance = 0.0;
  double dailyAllowance = 0.0;
  double todayTotalExpense = 0.0;
  List<TransactionModel> transactions = [];
  List<dynamic> upcomingBills = [];
  bool _loading = false;

  var logger = Logger();


  @override
  void initState()
  {
    super.initState();
    loadData();

    NotificationService().initNotifications();
  }


  // Monthly total expense function
  Future<void> loadData() async
  {
    if (_loading == true) return;

    setState(()
    {
      _loading = true;
    });

    try
    {
      final inc = await IncomeService().getMonthlyIncome();
      final exp = await ExpenseService().getMonthlyExpense();
      final tran = await TransactionService().getTodayTransactions();
      final pay = await BillService().getThisMonthTotalBillAmount();
      final criticalBills = await BillService().getUpcomingCriticalBills();

      DateTime now = DateTime.now();
      int totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;

      if (!mounted) return;

      final computedTodayExpense = tran
          .where((t) => t.type == "EXPENSE")
          .fold(0.0, (sum, t) => sum + t.amount);

      double computedSavingTarget = 0.0;

      if (inc > 0)
      {
        if (inc <=25000)
        {
          computedSavingTarget = inc * 0.05;
        }
        else if (inc < 60000)
        {
          computedSavingTarget = inc * 0.15;
        }
        else
        {
          computedSavingTarget = inc * 0.25;
        }

      }

      double safePool = inc - computedSavingTarget;



      setState(()
      {
        transactions =tran;
        income = inc;
        expense = exp;
        balance= income - expense;
        todayTotalExpense = computedTodayExpense;
        savingTarget = computedSavingTarget;
        upcomingBills = criticalBills;

        if (safePool > 0)
        {
          dailyAllowance = (safePool - pay) / totalDaysInMonth;
        }
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


  void _showAiSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.purple),
              title: const Text('Kamera ile Fotoğraf Çek'),
              onTap: ()
              {
                Navigator.pop(context);
                BillAiService().uploadAndProcessBill(
                  source: ImageSource.camera,
                  context: context,
                  onSuccess: loadData,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Galeriden Fiş Seç'),
              onTap: ()
              {
                Navigator.pop(context);
                BillAiService().uploadAndProcessBill(
                  source: ImageSource.gallery,
                  context: context,
                  onSuccess: loadData,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String getCategoryText(String? category)
  {
    switch (category)
    {
      case 'FOOD': return 'Yemek';
      case 'SNACKS': return 'Atıştırmalık';
      case 'HEALTH': return 'Sağlık';
      case 'BILLS': return 'Faturalar';
      case 'SHOPPING': return 'Alışveriş';
      case 'EDUCATION': return 'Eğitim';
      case 'TRANSPORT': return 'Ulaşım';
      case 'ENTERTAINMENT': return 'Eğlence';
      default: return 'Diğer';
    }
  }

  double getCategoryPercentage (String categoryName)
  {
    if (transactions.isEmpty || expense == 0) return 0;

    double categoryTotal = transactions
      .where((t) => t.type == "EXPENSE" && t.category == categoryName)
      .fold(0.0, (sum,t) => sum +t.amount);

    return (categoryTotal / todayTotalExpense) * 100;
  }

  @override
  Widget build(BuildContext context)
  {

    final bool todayHasNoExpense = transactions.where((t) => t.type == "EXPENSE").isEmpty;

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
                        height: 103,
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
              const Text("Günlük Harcama Limiti", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

              Text("₺${todayTotalExpense.toStringAsFixed(2)}/₺${dailyAllowance.toStringAsFixed(2)} ", style: TextStyle(fontSize: 18),),

              const SizedBox(height: 8),

              LinearProgressIndicator(value: (todayTotalExpense/dailyAllowance).clamp(0.0, 1.0),minHeight: 16,),

              const SizedBox(height: 20),

              // Fast Transactions
              const Text("Hızlı İşlemler", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

              const SizedBox(height: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Add income button
                      SizedBox(
                        width: 170,
                        height: 50,
                        child: ElevatedButton(
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
                          child: const Text("💵 Gelir Ekle"),
                        ),
                      ),

                      // Add bill button
                      SizedBox(
                        width: 170,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () async
                          {
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBillPage()));

                            if (result == true)
                            {
                              loadData();
                            }
                          },
                          icon: const Icon(Icons.receipt_long, size: 20),
                          label: const Text("Ödenecek Ekle",maxLines: 1,),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Add expense button
                      SizedBox(
                        width: 170,
                        height: 50,
                        child: ElevatedButton(
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
                          child: const Text("📉 Gider Ekle"),
                        ),
                      ),

                      // Add expense withe camere button
                      SizedBox(
                        width: 170,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            _showAiSourceOptions();
                          },
                          child: const Text("📷 Fiş"),
                        ),
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 20),

              if (upcomingBills.isNotEmpty) ...[
                const Text(
                  "🚨 Yaklaşan Ödemeler (Son 3 Gün)",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: upcomingBills.length,
                  itemBuilder: (context, index) {
                    final bill = upcomingBills[index];

                    DateTime pDate = DateTime.parse(bill['finalPaymentDate']);

                    return Card(
                      color: Colors.red.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        title: Text(bill['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Son Ödeme: ${pDate.day}.${pDate.month}.${pDate.year}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "₺${bill['amount']}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () async
                              {
                                bool success = await BillService().markAsPaid(bill['id']);
                                if (success)
                                {
                                  loadData();
                                }
                              },
                              child: const Text("ÖDE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 30),

              // Spend Pie Card
              const Text("Günlük Harcama Dağılımı", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
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
                        sections: todayHasNoExpense ?
                        [
                          PieChartSectionData(
                            value: 1,
                            title: "",
                            radius: 100,
                            color: Colors.grey.shade300,
                          ),
                        ]
                        : [
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
              const Text("Son İşlemler",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

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