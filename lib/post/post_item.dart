import 'package:flutter/material.dart';
import 'package:tp_flutter/core/models/post.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key, required this.post, required this.onTap});

  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title ?? ''),
      subtitle: Text(post.description ?? ''),
      onTap: onTap,
    );
  }
}
