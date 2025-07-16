import 'package:tp_flutter/core/models/post.dart';

import '../../enums/PostListStatus.dart';

class PostListState {
  final List<Post> posts;
  final PostListStatus postListStatus;
  final Exception? error;

  const PostListState({this.posts = const [], this.postListStatus = PostListStatus.initial, this.error});

  PostListState copyWith({List<Post>? posts,PostListStatus? postListStatus, Exception? error}) {
    return PostListState(
      posts: posts ?? this.posts,
      postListStatus: postListStatus ?? this.postListStatus,
      error: error ?? this.error
    );
  }
}