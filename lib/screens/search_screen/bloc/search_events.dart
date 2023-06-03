abstract class SearchEvent {}

class SearchInputEvent extends SearchEvent {}

class SearchSelectedEvent extends SearchEvent {
  final int index;

  SearchSelectedEvent({required this.index});
}

class SearchLoadingEvent extends SearchEvent {
  final String searchString;

  SearchLoadingEvent({required this.searchString});
}

class SearchRefreshEvent extends SearchEvent {}
