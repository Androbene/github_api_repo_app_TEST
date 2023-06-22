import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_api_repo_app/screens/search_screen/widgets/fav_button.dart';
import 'package:github_api_repo_app/screens/search_screen/widgets/found_repos_list.dart';
import 'package:github_api_repo_app/screens/search_screen/widgets/git_search_field.dart';
import 'package:github_api_repo_app/screens/search_screen/widgets/history_list.dart';
import '../../../themes/app_colors.dart';
import '../../constants/strings.dart';
import '../../../themes/styles.dart';
import 'bloc/search_block.dart';
import 'bloc/search_state.dart';

part 'elements.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchBloc _bloc = SearchBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Stack(
            alignment: Alignment.center,
            children: [
              searchTitleText,
              Align(
                alignment: Alignment.centerRight,
                child: FavButton(),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: BlocBuilder<SearchBloc, SearchScreenState>(
            bloc: _bloc,
            builder: (BuildContext context, screenState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const GitSearchField(),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: switch (_bloc.state.currState) {
                      CurrentState.emptyHistory => searchHistoryText,
                      CurrentState.fullHistory => searchHistoryText,
                      CurrentState.negativeRes => whatWeHaveFoundText,
                      CurrentState.positiveRes => whatWeHaveFoundText,
                      _ => const Text('')
                    },
                  ),
                  Expanded(
                      child: Center(
                          child: switch (_bloc.state.currState) {
                    CurrentState.emptyHistory => emptyHistoryText,
                    CurrentState.fullHistory => const HistoryList(),
                    CurrentState.loading => cupertinoIndicator,
                    CurrentState.negativeRes => nothingWasFoundText,
                    CurrentState.activeInput => FoundReposList(),
                    CurrentState.positiveRes => FoundReposList(),
                    CurrentState.error => Text(_bloc.state.errMsg),
                  }))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
