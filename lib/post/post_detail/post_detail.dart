import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_bloc.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_event.dart';
import 'package:tp_flutter/core/bloc/postBloc/post_state.dart';
import 'package:tp_flutter/core/bloc/postListBloc/post_list_bloc.dart';
import 'package:tp_flutter/core/bloc/postListBloc/post_list_event.dart';
import 'package:tp_flutter/core/bloc/userBloc/user_bloc.dart';
import 'package:tp_flutter/core/enums/PostStatus.dart';
import 'package:tp_flutter/core/models/post.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({super.key, required this.post});

  static const String routeName = '/postDetail';

  static void show(BuildContext context, Post post) async {
    await Navigator.of(context).pushNamed(routeName, arguments: post);
  }

  final Post post;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Post _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _isEditing = false;
    _titleController = TextEditingController(text: _post.title);
    _descriptionController = TextEditingController(
      text: _post.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _titleController.text = widget.post.title ?? '';
        _descriptionController.text = widget.post.description ?? '';
      }
    });
  }

  void _saveChanges(BuildContext context) {
    final String id = widget.post.id!;
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    context.read<PostBloc>().add(Edit(id, title, description));
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height;
    final double maxWidth = MediaQuery.of(context).size.width;
    final bool isAuthor =
        context.read<UserBloc>().state.user!.uid == widget.post.author;
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        print("edit in progress");
        if (state.postStatus == PostStatus.loading && !state.isDateUpdate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: SizedBox(
                  width: maxWidth * .1,
                  height: maxHeight * .05,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              backgroundColor: Colors.grey,
            ),
          );
        } else if (state.postStatus == PostStatus.updated) {
          print("edit Success");
          context.read<PostBloc>().add(LoadPost(_post.id!));
          context.read<PostListBLoc>().add(GetAllPosts());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mis à jour avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.postStatus == PostStatus.error) {
          print("edit failure");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la mise à jour'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.postStatus == PostStatus.loaded) {
          setState(() {
            _post = state.post;
            _titleController.text = _post.title ?? '';
            _descriptionController.text = _post.description ?? '';
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isEditing
              ? TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Titre',
                    border: UnderlineInputBorder(),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(_post.title ?? ''),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              spacing: 20,
              children: [
                _isEditing
                    ? TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Text('Description : ${_post.description}'),
                Text('created at : ${_post.createdAt}'),
                Text('updated at : ${_post.updateDate}'),
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () => _saveChanges(context),
                      child: const Text('Enregistrer'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: isAuthor
            ? FloatingActionButton(
                onPressed: _toggleEdit,
                child: Icon(_isEditing ? Icons.close : Icons.edit),
              )
            : null,
      ),
    );
  }
}
