class Customer {
  final int id;
  final String customerName;
  final String customerCode;
  final String remarks;

  Customer({
    required this.id,
    required this.customerName,
    required this.customerCode,
    required this.remarks,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"],
      customerName: json["customer_name"] ?? "",
      customerCode: json["customer_code"] ?? "",
      remarks: json["remarks"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customer_name": customerName,
      "customer_code": customerCode,
      "remarks": remarks,
    };
  }
}