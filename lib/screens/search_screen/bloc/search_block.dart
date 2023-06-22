import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_api_repo_app/api_clients/api_client_dart_io.dart';
import 'package:github_api_repo_app/screens/search_screen/bloc/search_events.dart';
import 'package:github_api_repo_app/screens/search_screen/bloc/search_state.dart';

import '../../../api_clients/api_client_http.dart';
import '../../../repository/favorites_repository.dart';
import '../../../models/git_repo.dart';
import '../../../constants/strings.dart';
import '../../../utils/internet.dart';

class SearchBloc extends Bloc<SearchEvent, SearchScreenState> {
  SearchBloc() : super(SearchScreenState.initial()) {
    on<SearchInputEvent>(_onSearchInputEvent);
    on<SearchLoadingEvent>(_onSearchLoadingEvent);
    on<SearchSelectedEvent>(_onSearchSelectedEvent);
    on<SearchClearEvent>(_onSearchClearEvent);
    on<SearchRefreshEvent>(_onSearchRefreshEvent);
  }

  Future<void> _onSearchInputEvent(
    SearchInputEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(currState: SearchState.activeInput));
  }

  Future<void> _onSearchLoadingEvent(
    SearchLoadingEvent event,
    Emitter emitter,
  ) async {
    if (event.searchString.trim().isEmpty) return;

    emitter(state.copyWith(
      searchString: event.searchString,
      currState: SearchState.loading,
    ));

    if (!await isInternetConnected()) {
      emitter(state.copyWith(
          currState: SearchState.error, errMsg: Strings.noInternet));
      return;
    }
    final result = await ApiClientHttp().getMappedRepos(event.searchString);
    if (result is List<GitRepo>) {
      final currState =
          result.isEmpty ? SearchState.negativeRes : SearchState.positiveRes;
      emitter(state.copyWith(currState: currState, repos: result));
    } else if (result is String) {
      emitter(state.copyWith(
          currState: SearchState.error,
          errMsg: "${Strings.gitServerError}: $result"));
    }
  }

  Future<void> _onSearchSelectedEvent(
    SearchSelectedEvent event,
    Emitter emitter,
  ) async {
    final oldValue = state.repos[event.index];
    final oldValIsFavorite = oldValue.isFav;
    final newValue = GitRepo(oldValue.url, oldValue.name, !oldValIsFavorite);

    // 1. change runtime favorites
    state.repos[event.index] = newValue;
    emitter(state.copyWith(
        currState: SearchState.positiveRes, repos: state.repos));

    // 2. change persist favorites
    if (oldValIsFavorite) {
      FavoritesRepository().remove(newValue);
    } else {
      FavoritesRepository().insert(newValue);
    }
  }

  Future<void> _onSearchClearEvent(
    SearchClearEvent event,
    Emitter emitter,
  ) async {
    emitter(state.copyWith(repos: []));
  }

  Future<void> _onSearchRefreshEvent(
    SearchRefreshEvent event,
    Emitter emitter,
  ) async {
    final List<GitRepo> refreshedRepos = [];
    for (var raw in state.repos) {
      refreshedRepos.add(GitRepo(
        raw.url,
        raw.name,
        await FavoritesRepository().isFavourite(raw),
      ));
    }
    emitter(state.copyWith(
        currState: SearchState.positiveRes, repos: refreshedRepos));
  }

  @override
  Future<void> close() {
    FavoritesRepository().closeRepo();
    return super.close();
  }
}
