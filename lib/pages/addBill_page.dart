import 'dart:math';

import 'package:finance_app/models/bill_request.dart';
import 'package:finance_app/services/bill_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddBillPage extends StatefulWidget
{
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends  State<AddBillPage>
{
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  bool isLoading = false;

  @override
  void dispose()
  {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async
  {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );

    if (picked != null)
    {
      setState(()
      {
        selectedDate = picked;
      });
    }
  }

  // Save a new bill function
  Future<void> saveBill() async
  {
    if (!_formKey.currentState!.validate()) return;

    setState(()
    {
      isLoading = true;
    });

    try
    {
      final request = CreateBillRequest(
        title: titleController.text,
        amount: double.parse(amountController.text),
        finalPaymentDate: selectedDate
      );

      final success = await BillService().createPayment(request);

      if (!mounted) return;
      
      if (success)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Başarıyla eklendi"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context,true);
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
           content: Text("Eklenemedi"),
           backgroundColor: Colors.red,
          ),
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
    finally
    {
      if (!mounted)
      {
        setState(()
        {
          isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: const Text("Ödenecek Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Ödenecek Adı"
                ),
                validator: (value)
                {
                  if (value == null || value.trim().isEmpty)
                  {
                    return "Ödenecek adı boş olamaz";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: amountController,
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

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsetsGeometry.symmetric(
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
                    Text("Son Ödeme Tarihi: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}"),
                    TextButton(onPressed: pickDate, child: const Text("Seç")),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveBill,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Ödeneceği Kaydet"),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

}