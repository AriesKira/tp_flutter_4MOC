import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_bloc.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_state.dart';
import 'package:tp_flutter/core/bloc/userBloc/user_bloc.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_event.dart';

import '../../core/bloc/postListBloc/post_list_bloc.dart';
import '../../core/bloc/postListBloc/post_list_event.dart';
import '../../core/enums/PostStatus.dart';

class CreatePost extends StatelessWidget {
  CreatePost({super.key});

  static const String routeName = "/createPost";

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créé un post")),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state.postStatus == PostStatus.loading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state.postStatus == PostStatus.error) {
            Navigator.of(context).pop(); // Ferme le loading
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.toString())),
            );
          } else if (state.postStatus == PostStatus.created || state.postStatus == PostStatus.updated) {
            Navigator.of(context, rootNavigator: true).pop();
            context.read<PostListBLoc>().add(GetAllPosts());
            Navigator.of(context).pop();
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                Text("Titre :"),
                Expanded(child: TextField(controller: titleController)),
              ],
            ),
            Row(
              children: [
                Text("Description :"),
                Expanded(child: TextField(controller: descriptionController)),
              ],
            ),
            ElevatedButton(
              onPressed: () => _createPost(context),
              child: Text("Crée"),
            ),
          ],
        ),
      ),
    );
  }

  void _createPost(BuildContext context) {
    String author = context.read<UserBloc>().state.user!.uid;
    String title = titleController.text;
    String description = descriptionController.text;
    context.read<PostBloc>().add(Create(title, description, author));
  }
}
