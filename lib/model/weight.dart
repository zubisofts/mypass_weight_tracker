import 'dart:convert';

import 'package:equatable/equatable.dart';

class Weight extends Equatable {
  final String? id;
  final String userId;
  final int value;
  final int timestamp;

  const Weight({
    this.id,
    required this.userId,
    required this.value,
    required this.timestamp,
  });

  Weight copyWith({
    String? id,
    String? userId,
    int? value,
    int? timestamp,
  }) {
    return Weight(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'value': value,
      'timestamp': timestamp,
    };
  }

  factory Weight.fromMap(Map<String, dynamic> map) {
    return Weight(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      value: map['value'] ?? '',
      timestamp: map['timestamp']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Weight.fromJson(String source) => Weight.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Weight(id: $id, userId: $userId, value: $value, timestamp: $timestamp)';
  }

  @override
  List<Object> get props => [id!, userId, value, timestamp];
}
