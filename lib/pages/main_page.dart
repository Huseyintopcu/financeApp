import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget
{
  const  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 🔥 SAYFALAR
  final List<Widget> _pages = [
    const HomeDashboard(),
    const Center(child: Text("İşlemler Sayfası")),
    const Center(child: Text("Analiz Sayfası")),
    const Center(child: Text("Ayarlar Sayfası")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.lightBlueAccent,
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            backgroundColor: Colors.lightBlueAccent,
            label: "İşlemler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            backgroundColor: Colors.lightBlueAccent,
            label: "Analiz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            backgroundColor: Colors.lightBlueAccent,
            label: "Ayarlar",
          ),
        ],
      ),
    );
  }
}



class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

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
            children: [

              // 💰 BAKİYE KARTI
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      Text("Toplam Bakiye",
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text("₺12,450",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🎯 TASARRUF HEDEFİ
              const Text("Tasarruf Hedefi"),

              const SizedBox(height: 8),

              LinearProgressIndicator(value: 0.6),

              const SizedBox(height: 20),

              // 📊 GÜNLÜK LİMİT
              const Text("Günlük Harcama Limiti"),

              const SizedBox(height: 8),

              LinearProgressIndicator(value: 0.3),

              const SizedBox(height: 20),

              // ⚡ HIZLI İŞLEMLER
              const Text("Hızlı İşlemler"),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  ElevatedButton(
                    onPressed: () {},
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

              // 🧾 SON İŞLEMLER
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
