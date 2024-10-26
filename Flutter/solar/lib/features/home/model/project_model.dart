// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final int totalShares; // Using camelCase for consistency
  final int sharesAvailable; // Using camelCase for consistency

  final double carbonReducedPerStock; // Use double instead of Float
  final double totalCarbonReduced; // Use double instead of Float
  final double? energyProduced; // Use double instead of Float

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.totalShares,
    required this.sharesAvailable,
    required this.carbonReducedPerStock,
    required this.totalCarbonReduced,
    this.energyProduced,
  });

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    int? totalShares,
    int? sharesAvailable,
    double? carbonReducedPerStock,
    double? totalCarbonReduced,
    double? energyProduced,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalShares: totalShares ?? this.totalShares,
      sharesAvailable: sharesAvailable ?? this.sharesAvailable,
      carbonReducedPerStock:
          carbonReducedPerStock ?? this.carbonReducedPerStock,
      totalCarbonReduced: totalCarbonReduced ?? this.totalCarbonReduced,
      energyProduced: energyProduced ?? this.energyProduced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'totalShares': totalShares,
      'sharesAvailable': sharesAvailable,
      'carbonReducedPerStock': carbonReducedPerStock,
      'totalCarbonReduced': totalCarbonReduced,
      'energyProduced': energyProduced,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      totalShares: (map['total_shares'] is int) ? map['total_shares'] : 0,
      sharesAvailable:
          (map['shares_available'] is int) ? map['shares_available'] : 0,
      carbonReducedPerStock: (map['carbon_reduced_per_stock'] is double)
          ? map['carbon_reduced_per_stock']
          : (map['carbon_reduced_per_stock'] is String
              ? double.tryParse(map['carbon_reduced_per_stock']) ?? 0.0
              : 0.0),
      totalCarbonReduced: (map['total_carbon_reduced'] is double)
          ? map['total_carbon_reduced']
          : (map['total_carbon_reduced'] is String
              ? double.tryParse(map['total_carbon_reduced']) ?? 0.0
              : 0.0),
      energyProduced: (map['energy_produced'] != null)
          ? (map['energy_produced'] is double
              ? map['energy_produced']
              : (map['energy_produced'] is String
                  ? double.tryParse(map['energy_produced'])
                  : null))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, description: $description, totalShares: $totalShares, sharesAvailable: $sharesAvailable, carbonReducedPerStock: $carbonReducedPerStock, totalCarbonReduced: $totalCarbonReduced, energyProduced: $energyProduced)';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.totalShares == totalShares &&
        other.sharesAvailable == sharesAvailable &&
        other.carbonReducedPerStock == carbonReducedPerStock &&
        other.totalCarbonReduced == totalCarbonReduced &&
        other.energyProduced == energyProduced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        totalShares.hashCode ^
        sharesAvailable.hashCode ^
        carbonReducedPerStock.hashCode ^
        totalCarbonReduced.hashCode ^
        energyProduced.hashCode;
  }
}
