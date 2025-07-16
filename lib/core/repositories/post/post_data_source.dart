import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_flutter/core/models/post.dart';

abstract class PostDataSource {
  Future<DocumentReference> createPost(String title, String description, String author);
  Future<List<Post>> getAllPosts();
  Future<void> editPost(String id, String title, String description);
  Future<Post> loadPost(String id);
}
