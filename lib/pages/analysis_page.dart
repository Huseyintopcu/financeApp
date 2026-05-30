import 'dart:math';

import 'package:finance_app/models/expense_category_extension.dart';
import 'package:finance_app/services/analysis_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/analysis_model.dart';

class AnalysisPage extends StatefulWidget
{
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
{
  List<AnalysisModel> data = [];
  bool isLoading = true;

  int selectedPeriod = 1;

  @override
  void initState()
  {
    super.initState();
    loadData();
  }

  Future<void> loadData() async
  {
    try
    {
      List<AnalysisModel> result;

      if (selectedPeriod == 0)
      {
        result = await AnalysisService().getWeeklyAnalysis();
      }
      else if (selectedPeriod == 1)
      {
        result = await AnalysisService().getMontlyAnalysis();
      }
      else
      {
        result = await AnalysisService().getAllAnalysis();
      }

      setState(()
      {
        data = result;
        isLoading = false;
      });
    }
    catch (e)
    {
      debugPrint("Analiz verisi yüklenirken hata oluştu: $e");
      setState(()
      {
        data = [];
        isLoading = false;

      });
    }
  }

  List<String> generateInsights()
  {
    List<String> insights = [];
    final random = Random();

    if (data.isEmpty)
    {
      insights.add("📭 Bu hafta henüz hiç harcama kaydetmedin. Harika bir tasarruf haftası!");
      return insights;
    }

    // Most spent category
    final maxExpenseItem = data.reduce((curr,next) => curr.total > next.total ? curr : next);
    final List<String> categoryMessages = [
      "📊 Bu dönem bütçeni en çok zorlayan kategori **${maxExpenseItem.category.trName}** oldu.",
      "💸 Harcamalarının lideri **${maxExpenseItem.category.trName}** kategorisi olarak görünüyor. Göz atmak isteyebilirsin.",
      "🎯 Bu dönemin en büyük harcama kalemi **${maxExpenseItem.category.trName}** bütçesinden gitmiş."
    ];
    insights.add(categoryMessages[random.nextInt(categoryMessages.length)]);

    // Weekly / monthly compare
    double currentPeriodTotal = 0;
    double previousPeriodTotal = 0;

    for (var item in data)
    {
      currentPeriodTotal += item.total;
      previousPeriodTotal += item.previousTotal ?? 0;
    }

    if (previousPeriodTotal > 0)
    {
      final double difference = currentPeriodTotal - previousPeriodTotal;
      final double percentage = (difference.abs() / previousPeriodTotal) * 100;

      final String periodText = selectedPeriod == 0 ? "geçen haftaya" : "geçen aya";

      if (difference > 0)
      {
        final List<String> moreExpenseMessages = [
          "⚠️ Dikkat! Bu dönem $periodText göre **%${percentage.toStringAsFixed(1)} daha fazla** (${difference.toStringAsFixed(2)} TL) harcadın.",
          "🚨 Bütçen biraz esnemiş. $periodText kıyasla harcamaların **%${percentage.toStringAsFixed(1)}** artışta görünüyor.",
          "📉 Tasarruf planını gözden geçirebilirsin; $periodText göre cebinden **${difference.toStringAsFixed(2)} TL** daha fazla çıkmış."
        ];
        insights.add(moreExpenseMessages[random.nextInt(moreExpenseMessages.length)]);     }
      else
      {
        final List<String> saveMessages = [
          "📉 Tebrikler! Bu dönem $periodText göre **%${percentage.toStringAsFixed(1)} daha tasarruflu** gidiyorsun.",
          "🌱 Harika gidiyorsun! $periodText kıyasla harcamalarını **%${percentage.toStringAsFixed(1)}** azaltmayı başardın.",
          "💰 Kumbara doluyor! Bu dönem $periodText göre tam **${difference.abs().toStringAsFixed(2)} TL** kardasın."
        ];
        insights.add(saveMessages[random.nextInt(saveMessages.length)]);      }
    }

    // Daily habit analysis
    const List<String> dayNames = ["","Pazartesi","Salı","Çarsamba","Perşembe","Cuma","Cumartesi","Pazar"];

    // Daily total for all categories
    Map<int,double> globalDailyTotals = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    Map<int,double> snackDailyTotals = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};

    for (var item in data)
    {
      if (item.dailyBreakdown != null)
      {
        item.dailyBreakdown!.forEach((day, amount)
        {
          globalDailyTotals[day] = (globalDailyTotals[day] ?? 0) + amount;

          if (item.category.name == "SNACKS")
          {
            snackDailyTotals[day] = (snackDailyTotals[day] ?? 0) + amount;
          }
        });
      }
    }

    // The day most spent
    int peakDay = 1;
    double  maxDayAmount = 0;
    globalDailyTotals.forEach((day, amount)
    {
      if (amount > maxDayAmount)
      {
        maxDayAmount = amount;
        peakDay = day;
      }
    });

    if (maxDayAmount > 0)
    {
      final List<String> dailyMessages = [
        "🛍️ Haftalık rutinine bakılırsa en çok harcamayı **${dayNames[peakDay]}** günleri yapıyorsun.",
        "📆 Haftanın alışveriş günü senin için **${dayNames[peakDay]}** gibi görünüyor. Cüzdan o gün hareketli!",
        "📌 İstatistiklere göre **${dayNames[peakDay]}** günleri diğer günlere kıyasla daha fazla kart çekiyorsun."
      ];
      insights.add(dailyMessages[random.nextInt(dailyMessages.length)]);    }

    // The week most spent
    if (selectedPeriod == 1)
    {
      Map<int, double> globalWeekTotals = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      for (var item in data)
      {
        if (item.weeklyBreakdown != null)
        {
          item.weeklyBreakdown!.forEach((week, amount)
          {
            globalWeekTotals[week] = (globalWeekTotals[week] ?? 0) + amount;
          });
        }
      }

      int peakWeek = 1;
      double maxWeekAmount = 0;

      globalWeekTotals.forEach((week, amount)
      {
        if (amount > maxWeekAmount)
        {
          maxWeekAmount = amount;
          peakWeek = week;
        }
      });

      if (maxWeekAmount > 0)
      {
        final List<String> weekMessages = [
          "📅 Ay içindeki harcama düzenine bakılırsa, en yüksek harcamayı **Ayın ${peakWeek}. Haftası** yapmışsın.",
          "🔍 Bu ayın finansal zirvesi **${peakWeek}. Haftada** gerçekleşmiş. O günleri bir hatırla istersen.",
          "🛒 Ayın **${peakWeek}. Haftasında** elin biraz fazla gevşemiş gibi görünüyor, harcamaların tavan yapmış."
        ];
        insights.add(weekMessages[random.nextInt(weekMessages.length)]);      }
    }

    // User habits for snacks
    int snackPeakDay = 1;
    double maxSnackAmount = 0;
    snackDailyTotals.forEach((day, amount)
    {
      if (amount > maxSnackAmount)
      {
        maxSnackAmount = amount;
        snackPeakDay = day;
      }
    });

    if (maxSnackAmount > 0)
    {
      final List<String> snackMessages = [
        "🍿 Küçük bir detay: **${dayNames[snackPeakDay]}** günleri canın biraz fazla atıştırmalık çekiyor gibi, harcaman tavan yapmış!",
        "🍪 **${dayNames[snackPeakDay]}** günleri abur cubur bütçen alarm veriyor! Kendini ödüllendirirken cüzdanını unutma.",
        "🍫 Alışkanlık raporuna göre haftalık kaçamak günün **${dayNames[snackPeakDay]}** olarak görünüyor. Küçük bir mola mı?",
        "🥤 **${dayNames[snackPeakDay]}** günü atıştırmalık harcamaların zirveyi görmüş. Stresli bir gün müydü, ne dersin?"
      ];

      final random = Random();
      final String selectedMessage = snackMessages[random.nextInt(snackMessages.length)];

      insights.add(selectedMessage);
    }

    return insights;
  }

  @override
  Widget build(BuildContext context)
  {
    final double totalExpenses = data.fold(0, (sum, item) => sum + item.total);
    final insights = generateInsights();

    return Scaffold(
      appBar: AppBar(title: const Text("Analizler")),
      body:Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoSegmentedControl<int>(
                groupValue: selectedPeriod,
                selectedColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                children: const
                {
                  0: Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 8),child: Text("Haftalık")),
                  1: Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 8),child: Text("Aylık")),
                  2: Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 8),child: Text("Tümü")),
                },
                onValueChanged: (value)
                {
                  setState(()
                  {
                    selectedPeriod = value;
                  });
                  loadData();
                },
              )
            ),
          ),

          const SizedBox(height: 8),

          // Pie Graph
          Expanded(
            child: isLoading
               ? const Center(child: CircularProgressIndicator())
               : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: data.isEmpty
                        ? const Center(
                          child: Text(
                            "Bu dönemde grafik çizilecek\nbir harcama bulunmuyor.",
                            style: TextStyle(color: Colors.grey),
                          ),
                         )
                        : PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 25,
                          sections: data.asMap().entries.map((entry)
                          {
                            final index = entry.key;
                            final e = entry.value;
                            final double percentage = totalExpenses > 0
                              ? (e.total/totalExpenses) * 100
                              : 0;

                            return PieChartSectionData(
                              value: e.total,
                              title: "%${percentage.toStringAsFixed(1)}",
                              radius: 85,
                              titlePositionPercentageOffset: 0.5,
                              color: Colors.primaries[index % Colors.primaries.length],
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Shows which color belongs to which category
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: data.asMap().entries.map((entry)
                        {
                          final index = entry.key;
                          final e = entry.value;
                          final color = Colors.primaries[index % Colors.primaries.length];

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                                
                              Text(
                                e.category.trName,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                             ],
                          );
                        },).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 16),
                       child: Card(
                         child: ListTile(
                           title: const Text("Toplam Harcama"),
                           trailing: Text(
                             "${totalExpenses.toStringAsFixed(2)} TL",
                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                           ),
                         ),
                       ),
                     ),

                     const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Finansal İçgörüler",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: insights.length,
                        itemBuilder: (context,index)
                        {
                          return Card(
                            elevation: 0,
                            color: Colors.amber.shade50,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.amber.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Icon(Icons.lightbulb_outline, color: Colors.amber,size: 28,),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      insights[index],
                                      style: const TextStyle(fontSize: 14,height: 1.3),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ]),
                  )
          )
        ],
      )
    );
  }
}