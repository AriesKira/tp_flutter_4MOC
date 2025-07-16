import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

final class Post {
  final String? id;
  final String? author;
  final String? title;
  final String? description;
  final DateTime? updateDate;
  final DateTime? createdAt;

  const Post({
    this.id,
    this.author,
    this.title,
    this.description,
    this.updateDate,
    this.createdAt
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      author: map['author'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updateDate: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] as String?,
      description: data['description'] as String?,
      author: data['author'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updateDate: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

}
