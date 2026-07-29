import 'package:flutter/material.dart';

import '../models/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(customer.id.toString()),
        ),
        title: Text(
          customer.customerName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Code : ${customer.customerCode}"),
            if (customer.remarks.isNotEmpty)
              Text(customer.remarks),
          ],
        ),
        trailing: const Icon(Icons.edit),
      ),
    );
  }
}