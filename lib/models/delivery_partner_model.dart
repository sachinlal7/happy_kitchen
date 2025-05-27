class DeliveryPartner {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final bool isAvailable;
  final double rating;
  final String phoneNumber;
  final String vehicleType;

  DeliveryPartner({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    required this.rating,
    required this.phoneNumber,
    required this.vehicleType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'isAvailable': isAvailable,
      'rating': rating,
      'phoneNumber': phoneNumber,
      'vehicleType': vehicleType,
    };
  }

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) {
    return DeliveryPartner(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      isAvailable: json['isAvailable'],
      rating: json['rating'].toDouble(),
      phoneNumber: json['phoneNumber'],
      vehicleType: json['vehicleType'],
    );
  }

  DeliveryPartner copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    bool? isAvailable,
    double? rating,
    String? phoneNumber,
    String? vehicleType,
  }) {
    return DeliveryPartner(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }
}
