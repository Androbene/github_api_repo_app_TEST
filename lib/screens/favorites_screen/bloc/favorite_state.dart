import 'package:github_api_repo_app/models/git_repo.dart';

enum FavourCurrentState { loading, empty, full }

class FavoriteScreenState {
  final FavourCurrentState currState;
  final List<GitRepo> repos;

  FavoriteScreenState({
    required this.currState,
    required this.repos,
  });

  factory FavoriteScreenState.initial() => FavoriteScreenState(
        currState: FavourCurrentState.loading,
        repos: [],
      );

  FavoriteScreenState copyWith({
    FavourCurrentState? currState,
    List<GitRepo>? repos,
  }) {
    return FavoriteScreenState(
      currState: currState ?? this.currState,
      repos: repos ?? this.repos,
    );
  }
}
