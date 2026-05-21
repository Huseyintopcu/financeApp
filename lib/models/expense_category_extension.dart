import 'package:finance_app/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

extension ExpenseCategoryExtension on ExpenseCategory
{
  String get trName
  {
    switch (this)
    {
      case ExpenseCategory.FOOD:
        return "Yemek";

      case ExpenseCategory.SNACKS:
        return "Atıştırmalık";

      case ExpenseCategory.TRANSPORT:
        return "Ulaşım";

      case ExpenseCategory.HEALTH:
        return "Sağlık";

      case ExpenseCategory.BILLS:
        return "Faturalar";

      case ExpenseCategory.ENTERTAINMENT:
        return "Eğlence";

      case ExpenseCategory.SHOPPING:
        return "Alışveriş";

      case ExpenseCategory.EDUCATION:
        return "Eğitim";

      case ExpenseCategory.OTHER:
        return "Diğer";
    }
  }

  IconData get icon
  {
    switch (this) {
      case ExpenseCategory.FOOD:
        return Icons.fastfood;

      case ExpenseCategory.SNACKS:
        return Icons.cookie;

      case ExpenseCategory.TRANSPORT:
        return Icons.directions_bus;

      case ExpenseCategory.HEALTH:
        return Icons.health_and_safety;

      case ExpenseCategory.BILLS:
        return Icons.receipt_long;

      case ExpenseCategory.ENTERTAINMENT:
        return Icons.movie;

      case ExpenseCategory.SHOPPING:
        return Icons.shopping_cart;

      case ExpenseCategory.EDUCATION:
        return Icons.school;

      case ExpenseCategory.OTHER:
        return Icons.category;
    }
  }

  Color get color
  {
    switch (this)
    {
      case ExpenseCategory.FOOD:
        return Colors.orange;

      case ExpenseCategory.SNACKS:
        return Colors.brown;

      case ExpenseCategory.TRANSPORT:
        return Colors.blue;

      case ExpenseCategory.HEALTH:
        return Colors.red;

      case ExpenseCategory.BILLS:
        return Colors.purple;

      case ExpenseCategory.ENTERTAINMENT:
        return Colors.pink;

      case ExpenseCategory.SHOPPING:
        return Colors.green;

      case ExpenseCategory.EDUCATION:
        return Colors.teal;

      case ExpenseCategory.OTHER:
        return Colors.grey;
    }
  }
}