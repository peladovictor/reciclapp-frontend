class Role {
  final String id; // si tu API usa strings como "CLIENT"
  final String name;
  final String image;
  final String route;
  final DateTime? createAt;
  final DateTime? updateAt;

  Role({
    required this.id,
    required this.name,
    required this.image,
    required this.route,
    this.createAt,
    this.updateAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      createAt: json['create_at'] != null ? DateTime.tryParse(json['create_at']) : null,
      updateAt: json['update_at'] != null ? DateTime.tryParse(json['update_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'route': route,
        'create_at': createAt?.toIso8601String(),
        'update_at': updateAt?.toIso8601String(),
      };
}
