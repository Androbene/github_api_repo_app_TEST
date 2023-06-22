import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_api_repo_app/repository/favorites_repository.dart';
import 'package:github_api_repo_app/models/git_repo.dart';
import 'favorite_events.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteScreenState> {
  FavoriteBloc() : super(FavoriteScreenState.initial()) {
    on<FavoriteEmptyEvent>(_onFavourEmptyEvent);
    on<FavoriteLoadedEvent>(_onFavourLoadedEvent);
    on<FavoriteSelectedEvent>(_onFavourSelectedEvent);
    _loadFromStorage();
  }

  Future _loadFromStorage() async {
    final allFav = await FavoritesRepository().getAll();
    final mappedFav = allFav.map((e) => GitRepo(e.url, e.name, true)).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    if (allFav.isEmpty) {
      add(FavoriteEmptyEvent());
    } else {
      add(FavoriteLoadedEvent(favorites: mappedFav));
    }
  }

  Future<void> _onFavourEmptyEvent(
    FavoriteEmptyEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(currState: FavoritesState.empty));
  }

  Future<void> _onFavourLoadedEvent(
    FavoriteLoadedEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(
      currState: FavoritesState.full,
      repos: event.favorites,
    ));
  }

  Future<void> _onFavourSelectedEvent(
    FavoriteSelectedEvent event,
    Emitter emitter,
  ) async {
    final clickedRepo = state.repos[event.index];
    final isClickedFavorite = clickedRepo.isFav;
    if (isClickedFavorite) {
      FavoritesRepository().remove(state.repos[event.index]);
    } else {
      FavoritesRepository().insert(state.repos[event.index]);
    }
    await _loadFromStorage();
  }

  @override
  Future<void> close() {
    FavoritesRepository().closeRepo();
    return super.close();
  }
}
