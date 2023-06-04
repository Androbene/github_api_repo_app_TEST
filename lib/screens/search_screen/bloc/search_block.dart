import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_api_repo_app/screens/search_screen/bloc/search_events.dart';
import 'package:github_api_repo_app/screens/search_screen/bloc/search_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    emitter(state.copyWith(currState: CurrentState.activeInput));
  }

  Future<void> _onSearchLoadingEvent(
    SearchLoadingEvent event,
    Emitter emitter,
  ) async {
    if (event.searchString.trim().isEmpty) return;

    emitter(state.copyWith(
      searchString: event.searchString,
      currState: CurrentState.loading,
    ));

    if (!await isInternetConnected()) {
      emitter(state.copyWith(
          currState: CurrentState.error, errMsg: Strings.noInternet));
      return;
    }

    try {
      const resultsPerPage = 15;
      final request =
          'https://api.github.com/search/repositories?q=${event.searchString}&sort=stars&order=desc&per_page=$resultsPerPage';
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final rawDataRepos = data['items']
            .map((item) => GitRepo(
                  item['html_url'] as String,
                  item['name'] as String,
                  false,
                ))
            .toList();

        final List<GitRepo> dataReposMappedFromStorage = [];
        for (var raw in rawDataRepos) {
          dataReposMappedFromStorage.add(GitRepo(
            raw.url,
            raw.name,
            await FavoritesRepository().isFavourite(raw),
          ));
        }

        if (dataReposMappedFromStorage.isEmpty) {
          emitter(state.copyWith(
              currState: CurrentState.negativeRes,
              repos: dataReposMappedFromStorage));
        } else {
          emitter(state.copyWith(
              currState: CurrentState.positiveRes,
              repos: dataReposMappedFromStorage));
        }
      } else {
        emitter(state.copyWith(
            currState: CurrentState.error,
            errMsg: "${Strings.gitServerError}: ${response.reasonPhrase}"));
      }
    } catch (e) {
      emitter(state.copyWith(
          currState: CurrentState.error,
          errMsg: "${Strings.gitServerError}: ${e.toString()}"));
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
        currState: CurrentState.positiveRes, repos: state.repos));

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
        currState: CurrentState.positiveRes, repos: refreshedRepos));
  }

  @override
  Future<void> close() {
    FavoritesRepository().closeRepo();
    return super.close();
  }
}
