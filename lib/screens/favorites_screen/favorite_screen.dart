import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_api_repo_app/constants/app_ic.dart';

import '../../constants/strings.dart';
import '../../themes/app_colors.dart';
import '../../themes/styles.dart';
import '../search_screen/search_screen.dart';
import 'bloc/favorite_block.dart';
import 'bloc/favorite_events.dart';
import 'bloc/favorite_state.dart';

part 'elements.dart';

class FavoriteScreen extends StatelessWidget {
  final FavoriteBloc _bloc = FavoriteBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteBloc>(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Stack(
            alignment: Alignment.center,
            children: [
              favoriteTitleText,
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              )
            ],
          ),
        ),
        body: BlocBuilder<FavoriteBloc, FavoriteScreenState>(
            bloc: _bloc,
            builder: (BuildContext context, screenState) {
              return switch (_bloc.state.currState) {
                FavourCurrentState.loading => cupertinoIndicator,
                FavourCurrentState.empty => noFavoritesText,
                FavourCurrentState.full => SavedFavoritesList()
              };
            }),
      ),
    );
  }
}
