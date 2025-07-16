import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_event.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_state.dart';
import 'package:tp_flutter/core/enums/PostStatus.dart';
import 'package:tp_flutter/core/models/post.dart';
import 'package:tp_flutter/core/repositories/post/post_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {

  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostState()) {
    on<Create>(_createPost);
    on<Edit>(_editPost);
    on<LoadPost>(_loadPost);
  }

  void _createPost(Create event, Emitter<PostState> emit) async {
    emit(state.copyWith(postStatus: PostStatus.loading));
    try {
      final DocumentReference _ = await postRepository.createPost(event.title, event.description, event.author);
      emit(state.copyWith(postStatus: PostStatus.created,));
    }on Exception catch (e) {
      emit(state.copyWith(postStatus: PostStatus.error, error: e));
    }
  }

  void _editPost(Edit event, Emitter<PostState> emit) async {
    emit(state.copyWith(postStatus: PostStatus.loading));
    try {
      await postRepository.editPost(event.id, event.title, event.description);
      emit(state.copyWith(postStatus: PostStatus.updated));
    }on Exception catch (e) {
      emit(state.copyWith(postStatus: PostStatus.error, error: e));
    }
  }

  FutureOr<void> _loadPost(LoadPost event, Emitter<PostState> emit) async {
    emit(state.copyWith(postStatus: PostStatus.loading, isDateUpdate: true));
    try {
      final Post loadedPost = await postRepository.loadPost(event.id);
      emit(state.copyWith(postStatus: PostStatus.loaded, post: loadedPost));
    }on Exception catch (e) {
      emit(state.copyWith(postStatus: PostStatus.error, error: e));
    }
  }
}