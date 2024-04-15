import 'dart:convert';

// Data class for location ratings
class Rating {
  final String id;
  final double ratingValue;
  final String uid;
  final String locationId;
  Rating({
    required this.id,
    required this.ratingValue,
    required this.uid,
    required this.locationId,
  });

  Rating copyWith({
    String? id,
    double? ratingValue,
    String? uid,
    String? locationId,
  }) {
    return Rating(
      id: id ?? this.id,
      ratingValue: ratingValue ?? this.ratingValue,
      uid: uid ?? this.uid,
      locationId: locationId ?? this.locationId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ratingValue': ratingValue,
      'uid': uid,
      'locationId': locationId,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      id: map['id'] as String,
      ratingValue: map['ratingValue'] as double,
      uid: map['uid'] as String,
      locationId: map['locationId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) =>
      Rating.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Rating(id: $id, ratingValue: $ratingValue, uid: $uid, locationId: $locationId)';
  }

  @override
  bool operator ==(covariant Rating other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ratingValue == ratingValue &&
        other.uid == uid &&
        other.locationId == locationId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ratingValue.hashCode ^
        uid.hashCode ^
        locationId.hashCode;
  }
}
