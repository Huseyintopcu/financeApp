import 'package:finance_app/models/expense_category.dart';
import 'package:finance_app/models/expense_category_extension.dart';
import 'package:finance_app/models/expense_model.dart';
import 'package:finance_app/services/expense_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget
{
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpense_pageState();
}

class _AddExpense_pageState extends State<AddExpensePage>
{
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  ExpenseCategory? selectedCategory;
  DateTime selectedDate = DateTime.now();

  bool isLoading = false;

  final List<ExpenseCategory> categories = ExpenseCategory.values;

  @override
  void dispose()
  {
    titleController.dispose();
    amountController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> saveExpense() async
  {
    if (!_formKey.currentState!.validate()) return;

    setState(()
    {
      isLoading = true;
    });

    try
    {
      final request = CreateExpenseRequest(
          title: titleController.text,
          amount: double.parse(amountController.text),
          category: selectedCategory!,
          quantity: int.parse(quantityController.text),
      );

      final succsess = await ExpenseService().createExpense(request);

      if (!mounted) return;

      if (succsess)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Gider eklendi"),
              backgroundColor: Colors.green,
            )
          );
          Navigator.pop(context);
        }
      else
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Gider eklenemedi"),
              backgroundColor: Colors.red,)
          );
        }
    }
    catch (e)
    {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text( "Gider Ekle"),),
      body:Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Ürün İsmi",
                ),
                validator: (value)
                {
                  if (value == null || value.isEmpty )
                    {
                      return "Ürün ismi alanı boş bırakılamaz";
                    }
                  return null;
                }
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: "Adet",
                ),
                validator: (value)
                  {
                    if (value == null || value.isEmpty)
                      {
                        return "Adet alanı boş bırakılamaz";
                      }
                    if (int.tryParse(value) == null)
                      {
                        return "Geçerli sayı giriniz";
                      }
                    return null;
                  }
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Tutar"
                ),
                validator: (value)
                  {
                    if (value == null || value.isEmpty)
                      {
                        return "Tutar alanı boş bırakılamaz";
                      }
                    if (double.tryParse(value) == null)
                      {
                        return "Geçerli sayı giriniz";
                      }
                    return null;
                  }
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<ExpenseCategory>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: categories.map((cat)
                {
                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(cat.icon, color: cat.color),
                        const SizedBox(width: 8),
                        Text(cat.trName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value)
                  {
                    setState(() => selectedCategory = value);
                  },
                validator: (v) => v == null ? "Kategori seç" : null,
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: isLoading ? null :saveExpense,
                    child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Gider Ekle")
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}