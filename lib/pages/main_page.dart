import 'package:finance_app/pages/addIncome_page.dart';
import 'package:finance_app/pages/settings_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                [
                  // Income Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          Text(
                              "Toplam Bakiye",
                              style: TextStyle(fontSize: 16)
                          ),
                          SizedBox(height: 10),
                          Text(
                              "₺12,450",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Savings Target Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Tassaruf Hedefi",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text(
                              "₺$savingTarget",
                            style: TextStyle(
                                fontSize: 24,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
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
                    onPressed: () 
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddIncomePage()),
                      );
                    },
                    child: const Text("+ Gelir"),
                  ),

                  ElevatedButton(
                    onPressed: () {},
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
              const Text("Harcama Dağılımı"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                        sections: [
                          PieChartSectionData(
                            value: 40,
                            title: "40%",
                            radius: 80,
                            color: Colors.red,
                          ),
                          PieChartSectionData(
                            value: 30,
                            title: "30%",
                            radius: 80,
                            color: Colors.blue,
                          ),
                          PieChartSectionData(
                            value: 20,
                            title: "20%",
                            radius: 80,
                            color: Colors.green,
                          ),
                          PieChartSectionData(
                            value: 10,
                            title: "10%",
                            radius: 80,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const[
                          LegendItem(color: Colors.red, text: "Yemek"),
                          LegendItem(color: Colors.blue, text: "Ulaşım"),
                          LegendItem(color: Colors.green, text: "Eğlence"),
                          LegendItem(color: Colors.orange, text: "Diğer"),
                        ],
                      ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // Last Transactions
              const Text("Son İşlemler"),

              const SizedBox(height: 10),

              ListTile(
                title: const Text("Migros"),
                trailing: const Text("-₺320"),
              ),

              ListTile(
                title: const Text("Maaş"),
                trailing: const Text("+₺15000"),
              ),

              ListTile(
                title: const Text("Spotify"),
                trailing: const Text("-₺59"),
              ),
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