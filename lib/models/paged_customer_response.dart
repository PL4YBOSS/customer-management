import 'customer.dart';

class PagedCustomerResponse {
  final List<Customer> customers;
  final int page;
  final int totalPages;
  final int totalRecords;

  PagedCustomerResponse({
    required this.customers,
    required this.page,
    required this.totalPages,
    required this.totalRecords,
  });

  factory PagedCustomerResponse.fromJson(
      Map<String, dynamic> json) {
    return PagedCustomerResponse(
      customers: (json["data"] as List)
          .map((e) => Customer.fromJson(e))
          .toList(),
      page: json["page"],
      totalPages: json["totalPages"],
      totalRecords: json["totalRecords"],
    );
  }
}