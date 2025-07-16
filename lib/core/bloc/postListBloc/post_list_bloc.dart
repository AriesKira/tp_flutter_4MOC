import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter/core/bloc/postListBloc/post_list_event.dart';
import 'package:tp_flutter/core/bloc/postListBloc/post_list_state.dart';
import 'package:tp_flutter/core/enums/PostListStatus.dart';
import 'package:tp_flutter/core/models/post.dart';
import 'package:tp_flutter/core/repositories/post/post_repository.dart';

class PostListBLoc extends Bloc<PostListEvent, PostListState> {
    final PostRepository postRepository;

    PostListBLoc({required this.postRepository}) : super(PostListState()) {
        on<GetAllPosts>(_getAllPosts);
    }

    void _getAllPosts(GetAllPosts event, Emitter<PostListState> emit) async {
        emit(state.copyWith(postListStatus: PostListStatus.loading));
        try {
            final List<Post> posts = await postRepository.getAllPosts();
            emit(state.copyWith(postListStatus: PostListStatus.loaded, posts: posts));
        }on Exception catch (e) {
            emit(state.copyWith(postListStatus: PostListStatus.error, error: e));
        }
    }
}
