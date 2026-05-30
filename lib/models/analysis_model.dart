import 'package:finance_app/models/expense_category.dart';
import 'package:flutter/foundation.dart';

class AnalysisModel
{
  final ExpenseCategory category;
  final double total;
  final double? previousTotal;
  final Map<int,double>? dailyBreakdown;
  final Map<int, double>? weeklyBreakdown;

  AnalysisModel(
  {
    required this.category,
    required this.total,
    this.previousTotal,
    this.dailyBreakdown,
    this.weeklyBreakdown

  });

  factory AnalysisModel.fromJson(Map<String,dynamic> json)
  {
    Map<int, double> dBreakdown = {};
    Map<int, double> wBreakdown = {};

    if (json["dailyBreakdown"] != null && json["dailyBreakdown"] is Map)
    {
      (json["dailyBreakdown"] as Map).forEach((key, value)
      {
        final intDay = int.tryParse(key.toString());
        final doubleAmount = (value as num).toDouble();
        if (intDay != null)
        {
          dBreakdown[intDay] = doubleAmount;
        }
      });
    }

    if (json["weeklyBreakdown"] != null && json["weeklyBreakdown"] is Map)
    {
      (json["weeklyBreakdown"] as Map).forEach((key, value)
      {
        final intWeek = int.tryParse(key.toString());
        final doubleAmount = (value as  num).toDouble();
        if (intWeek != null)
        {
          wBreakdown[intWeek] = doubleAmount;
        }
      });
    }

    return AnalysisModel(
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.values.first,
      ),
      total: json["total"].toDouble(),
      previousTotal: json['previousTotal'] != null ? (json['previousTotal'] as num).toDouble() : null,
      dailyBreakdown: dBreakdown,
      weeklyBreakdown: wBreakdown,
    );
  }
}