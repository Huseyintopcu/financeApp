import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:finance_app/models/Income_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../services/Income_service.dart';

class AddIncomePage extends StatefulWidget
{
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage>
{
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  DateTime selectedDate = DateTime.now();

  bool isLoading = false;

  // Select Date Function
  Future<void> pickDate() async
  {
    final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
    );

    if (picked != null)
      {
        setState(()
          {
            selectedDate = picked;
          }
        );
      }
  }

  // Save Income Function
  Future<void> saveIncome() async
  {
    if (!_formKey.currentState!.validate()) return;

    setState(()
    {
      isLoading = true;
    });

    try
    {
      final request = CreateIncomeRequest(
          title: _titleController.text,
          amount: double.parse(_amountController.text),
          transactionDate: selectedDate,
      );

      final token = await storage.read(key: "token");

      if (token == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Oturum bulunamadı"),
          ),
        );

        setState(() {
          isLoading = false;
        });

        return;
      }

      final success = await IncomeService().createIncome(
        request,
        token,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gelir başarıyla eklendi"),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gelir eklenemedi"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: $e"),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context)
  {
    return Scaffold(appBar: AppBar(title: const Text("Gelir Ekle"),),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Gelir Başlığı"
              ),
              validator: (value)
              {
                if (value == null || value.trim().isEmpty)
                  {
                    return "Başlık boş olamaz";
                  }
                return null;
              },
            ),

            const SizedBox(height: 16,),

            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: "Miktar",
              ),
              validator: (value)
              {
                if (value == null || value.isEmpty)
                  {
                    return "Miktar giriniz";
                  }
                if (double.tryParse(value) == null)
                  {
                    return "Geçerli sayı giriniz";
                  }
                return null;
              },
            ),

            const SizedBox(height: 16,),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tarih: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}",),
                  TextButton(
                    onPressed: pickDate,
                    child: const Text("Seç"),),
                ],
              ),
            ),

            const SizedBox(height: 16,),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                  onPressed: isLoading ? null :saveIncome,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Geliri Kaydet"),
              ),
            )
          ],
        ),
      )
    ),
    );

  }
}