import 'package:tp_flutter/core/models/post.dart';

import '../../enums/PostStatus.dart';

class PostState {
  final PostStatus postStatus;
  final Post post;
  final bool isDateUpdate;
  final Exception? error;

  const PostState({
    this.postStatus = PostStatus.initial,
    this.post = const Post(),
    this.isDateUpdate = false,
    this.error,
  });

  PostState copyWith({PostStatus? postStatus, Post? post,bool? isDateUpdate, Exception? error}) {
    return PostState(
      postStatus: postStatus ?? this.postStatus,
      post: post ?? this.post,
      isDateUpdate:isDateUpdate ?? false,
      error: error ?? this.error,
    );
  }
}
