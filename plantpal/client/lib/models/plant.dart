class Plant {
  final int id;
  final String name;
  final String species;
  final DateTime? purchaseDate;
  final String? location;
  final String? photoUrl;
  final int categoryId;
  final String? categoryName;
  final List<dynamic> lastCareLogs;   // ← новое поле

  Plant({
    required this.id,
    required this.name,
    required this.species,
    this.purchaseDate,
    this.location,
    this.photoUrl,
    required this.categoryId,
    this.categoryName,
    this.lastCareLogs = const [],
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      purchaseDate: json['purchase_date'] != null ? DateTime.parse(json['purchase_date']) : null,
      location: json['location'],
      photoUrl: json['photo_url'],
      categoryId: json['category_id'],
      categoryName: json['category']?['name'],
      lastCareLogs: json['last_care_logs'] ?? [],
    );
  }
}
