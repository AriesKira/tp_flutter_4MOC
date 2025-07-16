import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_flutter/core/models/post.dart';
import 'package:tp_flutter/core/repositories/post/post_data_source.dart';

class PostDatasSourceImpl extends PostDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<DocumentReference> createPost(String title, String description, String author) async {
    try {
      final postRef = await _firestore.collection('posts').add({
        'title': title,
        'description': description,
        'author': author,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return postRef;
    }catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      final querySnapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Post.fromMap(data, doc.id);
      }).toList();

    }catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editPost(String id, String title, String description) async {
    try {
      await _firestore
          .collection('posts')
          .doc(id)
          .update({
        'title': title,
        'description': description,
      });
    }catch (e) {
      rethrow;
    }
  }

  @override
  Future<Post> loadPost(String id) async {
    try {
      final DocumentSnapshot postDoc =  await _firestore
          .collection('posts')
          .doc(id)
          .get();

      if (!postDoc.exists) {
        throw Exception('Post Not Found');
      }

      return Post.fromDocument(postDoc);
    }catch (e) {
      rethrow;
    }
  }

}