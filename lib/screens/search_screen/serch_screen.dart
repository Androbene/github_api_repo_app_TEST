import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_api_repo_app/screens/search_screen/widgets/git_search_field.dart';
import '../../../themes/app_colors.dart';
import '../../constants/strings.dart';
import '../../../themes/styles.dart';
import '../../themes/overlays.dart';
import 'bloc/history_case.dart';
import 'bloc/search_block.dart';
import 'bloc/search_events.dart';
import 'bloc/search_state.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchBloc _bloc = SearchBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        color: AppColors.main,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: BlocBuilder<SearchBloc, SearchScreenState>(
            bloc: _bloc,
            builder: (BuildContext context, screenState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GitSearchField(
                      onFocusedCallback: () => _bloc.add(SearchInputEvent()),
                      onSearchCallback: (String searchString) {
                        if (_bloc.state.currState != CurrentState.loading) {
                          SearchHistoryCase().save(searchString);
                          _bloc.add(
                              SearchLoadingEvent(searchString: searchString));
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildResultTitleArea(),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Center(child: _buildResultArea()),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Text _buildResultTitleArea() {
    switch (_bloc.state.currState) {
      case CurrentState.emptyHistory:
      case CurrentState.fullHistory:
        return Text(
          Strings.searchHistory,
          style: AppStyles.textHeaderBlue,
          textAlign: TextAlign.left,
        );
      case CurrentState.negativeRes:
      case CurrentState.positiveRes:
        return Text(
          Strings.whatWeHaveFound,
          style: AppStyles.textHeaderBlue,
          textAlign: TextAlign.left,
        );
      default:
        return const Text('');
    }
  }

  Widget _buildResultArea() {
    switch (_bloc.state.currState) {
      case CurrentState.emptyHistory:
        return Text(
          Strings.emptyHistory,
          textAlign: TextAlign.center,
          style: AppStyles.textHolder,
        );
      case CurrentState.fullHistory:
        return _renderHistoryList();
      case CurrentState.loading:
        return const Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 22),
            child: CupertinoActivityIndicator(
              color: AppColors.progressCupertino,
              radius: 11.0,
            ),
          ),
        );
      case CurrentState.negativeRes:
        return Text(
          Strings.nothingWasFound,
          textAlign: TextAlign.center,
          style: AppStyles.textHolder,
        );
      case CurrentState.positiveRes:
        return _renderReposList();
      case CurrentState.error:
        return Text(_bloc.state.errMsg);
      default:
        return const Text('');
    }
  }

  ListView _renderReposList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _bloc.state.repos.length,
      itemBuilder: (BuildContext context, int index) {
        var isFavourite = _bloc.state.repos[index].isFav;
        return Card(
            color: AppColors.layer1,
            elevation: 0,
            shadowColor: Colors.blue,
            margin: const EdgeInsets.all(5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                _bloc.state.repos[index].name,
                style: AppStyles.textBody,
              ),
              trailing: InkWell(
                onTap: () {
                  _bloc.add(SearchSelectedEvent(index: index));
                },
                child: isFavourite
                    ? SvgPicture.asset(
                        'assets/icons/ic_star_favourite.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/ic_star_not_favourite.svg',
                      ),
              ),
            ));
      },
    );
  }

  Widget _renderHistoryList() {
    final historyData = SearchHistoryCase().load().reversed.toList();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: historyData.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            color: AppColors.layer1,
            elevation: 0,
            shadowColor: Colors.blue,
            margin: const EdgeInsets.all(5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                historyData[index],
                style: AppStyles.textBody,
              ),
            ));
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: AppColors.main,
      backgroundColor: AppColors.main,
      elevation: 1.5,
      shadowColor: AppColors.layer1,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              Strings.searchTitle,
              textAlign: TextAlign.center,
              style: AppStyles.textHeader,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 52,
              height: 52
              ,
              child: IconButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, "favourites_screen");
                    _bloc.add(SearchRefreshEvent());
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/ic_favourite.svg',
                  )),
            ),
          )
        ],
      ),
      systemOverlayStyle: lightStatusBar,
    );
  }
}
