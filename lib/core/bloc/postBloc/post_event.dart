abstract class PostEvent {
  const PostEvent();
}

final class Create extends PostEvent {
  final String title;
  final String description;
  final String author;

  const Create(this.title, this.description, this.author);
}

final class Edit extends PostEvent {
  final String id;
  final String title;
  final String description;

  const Edit(this.id, this.title, this.description);
}

final class LoadPost extends PostEvent {
  final String id;

  const LoadPost(this.id);
}