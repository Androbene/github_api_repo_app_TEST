import 'package:github_api_repo_app/models/git_repo.dart';

abstract class FavoriteEvent {}

class FavoriteLoadedEvent extends FavoriteEvent {
  final List<GitRepo> favorites;

  FavoriteLoadedEvent({required this.favorites});
}

class FavoriteEmptyEvent extends FavoriteEvent {}

class FavoriteSelectedEvent extends FavoriteEvent {
  final int index;

  FavoriteSelectedEvent({required this.index});
}
