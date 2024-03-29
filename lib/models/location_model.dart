// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

class LocationModel {
  final String id;

  final double x;
  final double y;

  final String name;
  final String details;
  final List<String> photos;
  final Set<String> moderators;
  final bool isVerified;
  LocationModel({
    required this.id,
    required this.x,
    required this.y,
    required this.name,
    required this.details,
    required this.photos,
    required this.moderators,
    required this.isVerified,
  });

  LocationModel copyWith({
    String? id,
    double? x,
    double? y,
    String? name,
    String? details,
    List<String>? photos,
    Set<String>? moderators,
    bool? isVerified,
  }) {
    return LocationModel(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      name: name ?? this.name,
      details: details ?? this.details,
      photos: photos ?? this.photos,
      moderators: moderators ?? this.moderators,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'x': x,
      'y': y,
      'name': name,
      'details': details,
      'photos': photos,
      'moderators': moderators,
      'isVerified': isVerified,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as String,
      x: map['x'].toDouble() as double,
      y: map['y'].toDouble() as double,
      name: map['name'] as String,
      details: map['details'] as String,
      photos: (map['photos'] as List).cast<String>(),
      moderators: (map['moderators'] as List<dynamic>).cast<String>().toSet(),
      isVerified: map['isVerified'] as bool,
    );
  }

  @override
  String toString() {
    return 'LocationModel(id: $id, x: $x, y: $y, name: $name, details: $details photos: $photos, moderators: $moderators, isVerified: $isVerified)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.x == x &&
        other.y == y &&
        other.name == name &&
        other.details == details &&
        listEquals(other.photos, photos) &&
        setEquals(other.moderators, moderators) &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        x.hashCode ^
        y.hashCode ^
        name.hashCode ^
        details.hashCode ^
        photos.hashCode ^
        moderators.hashCode ^
        isVerified.hashCode;
  }
}
