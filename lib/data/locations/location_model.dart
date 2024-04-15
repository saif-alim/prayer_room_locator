import 'package:flutter/foundation.dart';

// Data Class for Location
class LocationModel {
  final String id;

  final double latitude;
  final double longitude;

  final String name;
  final String details;
  final List<String> photos;
  final Set<String> moderators;
  final bool isVerified;
  final List<String> amenities;

  LocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.details,
    required this.photos,
    required this.moderators,
    required this.isVerified,
    required this.amenities,
  });

  LocationModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? name,
    String? details,
    List<String>? photos,
    Set<String>? moderators,
    bool? isVerified,
    List<String>? amenities,
  }) {
    return LocationModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      details: details ?? this.details,
      photos: photos ?? this.photos,
      moderators: moderators ?? this.moderators,
      isVerified: isVerified ?? this.isVerified,
      amenities: amenities ?? this.amenities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'details': details,
      'photos': photos,
      'moderators': moderators,
      'isVerified': isVerified,
      'amenities': amenities,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as String,
      latitude: map['latitude'].toDouble() as double,
      longitude: map['longitude'].toDouble() as double,
      name: map['name'] as String,
      details: map['details'] as String,
      photos: (map['photos'] as List).cast<String>(),
      moderators: (map['moderators'] as List<dynamic>).cast<String>().toSet(),
      isVerified: map['isVerified'] as bool,
      amenities: (map['amenities'] as List).cast<String>(),
    );
  }

  @override
  String toString() {
    return 'LocationModel(name: $name, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.name == name &&
        other.details == details &&
        listEquals(other.photos, photos) &&
        setEquals(other.moderators, moderators) &&
        other.isVerified == isVerified &&
        listEquals(other.amenities, amenities);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        name.hashCode ^
        details.hashCode ^
        photos.hashCode ^
        moderators.hashCode ^
        isVerified.hashCode ^
        amenities.hashCode;
  }
}
