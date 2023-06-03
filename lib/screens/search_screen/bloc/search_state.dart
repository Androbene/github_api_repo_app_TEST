import '../../../models/git_repo.dart';
import 'history_case.dart';

enum CurrentState {
  emptyHistory,
  fullHistory,
  activeInput,
  loading,
  positiveRes,
  negativeRes,
  error,
}

class SearchScreenState {
  final CurrentState currState;
  final String searchString;
  final List<GitRepo> repos;
  final String errMsg;

  SearchScreenState({
    required this.currState,
    required this.searchString,
    required this.repos,
    required this.errMsg,
  });

  factory SearchScreenState.initial() {
    final initialState = SearchHistoryCase().load().isEmpty
        ? CurrentState.emptyHistory
        : CurrentState.fullHistory;
    return SearchScreenState(
      currState: initialState,
      searchString: '',
      repos: [],
      errMsg: '',
    );
  }

  SearchScreenState copyWith({
    CurrentState? currState,
    String? searchString,
    List<GitRepo>? repos,
    String? errMsg,
  }) {
    return SearchScreenState(
      currState: currState ?? this.currState,
      searchString: searchString ?? this.searchString,
      repos: repos ?? this.repos,
      errMsg: errMsg ?? this.errMsg,
    );
  }
}
