import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter/core/bloc/postListBloc/post_list_bloc.dart';
import 'package:tp_flutter/core/bloc/postListBloc/post_list_state.dart';
import 'package:tp_flutter/core/enums/PostListStatus.dart';
import 'package:tp_flutter/core/models/post.dart';
import 'package:tp_flutter/post/create_post/create_post.dart';
import 'package:tp_flutter/post/post_detail/post_detail.dart';
import 'package:tp_flutter/post/post_item.dart';

import '../../core/bloc/postListBloc/post_list_event.dart';
import '../../core/bloc/userBloc/user_bloc.dart';
import '../../core/bloc/userBloc/user_event.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  void initState() {
    super.initState();
    final postListBloc = BlocProvider.of<PostListBLoc>(context);
    postListBloc.add(GetAllPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          ElevatedButton(
            onPressed: () => _logout(context),
            child: Text("Logout"),
          ),
        ],
      ),
      body: BlocBuilder<PostListBLoc, PostListState>(
        builder: (context, state) {
          return switch (state.postListStatus) {
            PostListStatus.initial ||
            PostListStatus.loading => _buildLoading(context),
            PostListStatus.loaded => _buildPostList(context, state.posts),
            PostListStatus.error => _buildError(context, state.error),
          };
        },
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(BuildContext context, Exception? error) {
    return Center(
      child: Text(
        error?.toString() ?? 'Erreur inconnue',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const Center(child: Text('Aucun post actuellement'));
  }

  Widget _buildPostList(BuildContext context, List<Post> posts) {
    if (posts.isEmpty) return _buildEmpty(context);

    return Column(
      children: [
        Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => _navigateToCreatePost(context),
                child: Icon(Icons.add),
              ),
              TextButton(
                onPressed: () => throw Exception(),
                child: const Text("Throw Test Exception"),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostItem(
                post: post,
                onTap: () => _onPostTap(context, post),
              );
            },
          ),
        ),
      ],
    );
  }

  void _logout(BuildContext context) {
    context.read<UserBloc>().add(Logout());
  }

  void _navigateToCreatePost(BuildContext context) {
    return CreatePost.navigateTo(context);
  }

  void _onPostTap(BuildContext context, Post post) {
    PostDetail.show(context, post);
  }
}
