import 'package:atap_bumi_apps/models/equipment.dart';
import 'package:atap_bumi_apps/models/user.dart';

class Review {
  final int id;
  final int rentalId;
  final int equipmentId;
  final int userId;
  final int rating;
  final String? comment;
  final List<String>? reviewPhotos;
  final bool isVerified;
  final DateTime createdAt;
  final User? user;
  final Equipment? equipment;

  Review({
    required this.id,
    required this.rentalId,
    required this.equipmentId,
    required this.userId,
    required this.rating,
    this.comment,
    this.reviewPhotos,
    required this.isVerified,
    required this.createdAt,
    this.user,
    this.equipment,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    rentalId: json['rental_id'],
    equipmentId: json['equipment_id'],
    userId: json['user_id'],
    rating: json['rating'],
    comment: json['comment'],
    reviewPhotos:
        json['review_photos'] != null
            ? List<String>.from(json['review_photos'])
            : null,
    isVerified: json['is_verified'] ?? true,
    createdAt: DateTime.parse(json['created_at']),
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    equipment:
        json['equipment'] != null
            ? Equipment.fromJson(json['equipment'])
            : null,
  );

  Map<String, dynamic> toJson() => {
    'rental_id': rentalId,
    'equipment_id': equipmentId,
    'rating': rating,
    'comment': comment,
  };

  String get ratingStars => '★' * rating + '☆' * (5 - rating);
}
