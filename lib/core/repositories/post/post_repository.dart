import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_flutter/core/repositories/post/post_data_source.dart';

import '../../models/post.dart';

class PostRepository {
  final PostDataSource postDataSource;

  const PostRepository({required this.postDataSource});

  Future<DocumentReference> createPost(String title, String description, String author) async {
   try {
     return await postDataSource.createPost(title, description, author);
   }catch (e) {
     rethrow;
   }
  }

  Future<List<Post>> getAllPosts() async {
    try {
      return await postDataSource.getAllPosts();
    }catch (e) {
      rethrow;
    }
  }

  Future<Post> loadPost(String id) async {
    try {
      return await postDataSource.loadPost(id);
    }catch (e) {
      rethrow;
    }
  }

  Future<void> editPost(String id, String title, String description) async {
    try {
      await postDataSource.editPost(id,title,description);
    }catch (e) {
      rethrow;
    }
  }
}