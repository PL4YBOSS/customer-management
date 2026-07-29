import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/customer.dart';
import '../models/paged_customer_response.dart';
import '../utils/constants.dart';

class ApiService {
  // Get Customers with Pagination
  static Future<PagedCustomerResponse> getCustomers({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}?page=$page&limit=$limit"),
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to load customers");
    }

    return PagedCustomerResponse.fromJson(
      jsonDecode(response.body),
    );
  }

  // Search Customers
  static Future<List<Customer>> searchCustomers(String keyword) async {
    final response = await http.get(
      Uri.parse(
        "${AppConstants.baseUrl}/search?q=${Uri.encodeComponent(keyword)}",
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Search failed");
    }

    final json = jsonDecode(response.body);

    return (json["data"] as List)
        .map((e) => Customer.fromJson(e))
        .toList();
  }

  // Add Customer
  static Future<bool> addCustomer({
    required String customerName,
    required String customerCode,
    required String remarks,
  }) async {
    final response = await http.post(
      Uri.parse(AppConstants.baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "customer_name": customerName,
        "customer_code": customerCode,
        "remarks": remarks,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  // Update Customer
  static Future<bool> updateCustomer({
    required int id,
    required String customerName,
    required String customerCode,
    required String remarks,
  }) async {
    final response = await http.put(
      Uri.parse("${AppConstants.baseUrl}/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "customer_name": customerName,
        "customer_code": customerCode,
        "remarks": remarks,
      }),
    );

    return response.statusCode == 200;
  }
}