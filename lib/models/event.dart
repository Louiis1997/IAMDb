enum EventStatus { upcoming, live, past }

class Event {
  final String id;
  final String name;
  final String description;
  final String category;
  final String organizer;
  final String city;
  final String address;
  final String zipCode;
  final String country;
  final double latitude;
  final double longitude;
  final DateTime startDate;
  final DateTime? endDate;
  final String status;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.organizer,
    required this.city,
    required this.address,
    required this.zipCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.cancelledAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      organizer: json['organizer'],
      city: json['city'],
      address: json['address'],
      zipCode: json['zipCode'],
      country: json['country'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: EventStatus.values
          .byName(json['status'].toString().toLowerCase())
          .toString(),
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  @override
  String toString() {
    return 'Event{id: $id, name: $name, description: $description, category: $category, organizer: $organizer, city: $city, address: $address, zipCode: $zipCode, country: $country, latitude: $latitude, longitude: $longitude, startDate: $startDate, endDate: $endDate, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
