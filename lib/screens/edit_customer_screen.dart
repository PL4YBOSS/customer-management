import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../services/api_service.dart';

class EditCustomerScreen extends StatefulWidget {
  final Customer customer;

  const EditCustomerScreen({
    super.key,
    required this.customer,
  });

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController codeController;
  late TextEditingController remarksController;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.customer.customerName);

    codeController =
        TextEditingController(text: widget.customer.customerCode);

    remarksController =
        TextEditingController(text: widget.customer.remarks);
  }

  Future<void> updateCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      saving = true;
    });

    final success = await ApiService.updateCustomer(
      id: widget.customer.id,
      customerName: nameController.text.trim(),
      customerCode: codeController.text.trim(),
      remarks: remarksController.text.trim(),
    );

    setState(() {
      saving = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Customer updated successfully"),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Update failed"),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Customer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter customer name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: "Customer Code",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter customer code";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: remarksController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Remarks",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: saving ? null : updateCustomer,
                  child: saving
                      ? const CircularProgressIndicator()
                      : const Text("UPDATE CUSTOMER"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}