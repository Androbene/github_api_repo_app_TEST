import 'package:github_api_repo_app/models/git_repo.dart';

enum FavoritesState { loading, empty, full }

class FavoriteScreenState {
  final FavoritesState currState;
  final List<GitRepo> repos;

  FavoriteScreenState({
    required this.currState,
    required this.repos,
  });

  factory FavoriteScreenState.initial() => FavoriteScreenState(
        currState: FavoritesState.loading,
        repos: [],
      );

  FavoriteScreenState copyWith({
    FavoritesState? currState,
    List<GitRepo>? repos,
  }) {
    return FavoriteScreenState(
      currState: currState ?? this.currState,
      repos: repos ?? this.repos,
    );
  }
}
