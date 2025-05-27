class Order {
  final String id;
  final String customerName;
  final String customerAddress;
  final double customerLatitude;
  final double customerLongitude;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime createdAt;
  String status;
  String? assignedPartnerId;

  Order({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.customerLatitude,
    required this.customerLongitude,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    this.status = 'pending',
    this.assignedPartnerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerLatitude': customerLatitude,
      'customerLongitude': customerLongitude,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'assignedPartnerId': assignedPartnerId,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerName: json['customerName'],
      customerAddress: json['customerAddress'],
      customerLatitude: json['customerLatitude'].toDouble(),
      customerLongitude: json['customerLongitude'].toDouble(),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 'pending',
      assignedPartnerId: json['assignedPartnerId'],
    );
  }

  Order copyWith({
    String? id,
    String? customerName,
    String? customerAddress,
    double? customerLatitude,
    double? customerLongitude,
    List<OrderItem>? items,
    double? totalAmount,
    DateTime? createdAt,
    String? status,
    String? assignedPartnerId,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      customerLatitude: customerLatitude ?? this.customerLatitude,
      customerLongitude: customerLongitude ?? this.customerLongitude,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      assignedPartnerId: assignedPartnerId ?? this.assignedPartnerId,
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  OrderItem copyWith({
    String? name,
    int? quantity,
    double? price,
  }) {
    return OrderItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
