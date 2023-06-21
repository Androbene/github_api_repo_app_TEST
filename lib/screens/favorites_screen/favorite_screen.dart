import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:github_api_repo_app/constants/app_ic.dart';

import '../../constants/strings.dart';
import '../../themes/app_colors.dart';
import '../../themes/styles.dart';
import 'bloc/favorite_block.dart';
import 'bloc/favorite_events.dart';
import 'bloc/favorite_state.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  final FavoriteBloc _bloc = FavoriteBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<FavoriteBloc, FavoriteScreenState>(
          bloc: _bloc,
          builder: (BuildContext context, screenState) {
            return _buildMainContentArea();
          }),
    );
  }

  Widget _buildMainContentArea() {
    switch (_bloc.state.currState) {
      case FavourCurrentState.loading:
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
      case FavourCurrentState.empty:
        return const Center(
            child: Text(
          Strings.noFavorites,
          textAlign: TextAlign.center,
          style: AppStyles.textHolder,
        ));
      case FavourCurrentState.full:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: _buildFullList(),
        );
      default:
        return const Text('');
    }
  }

  ListView _buildFullList() {
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
                  _bloc.add(FavoriteSelectedEvent(index: index));
                },
                child: isFavourite
                    ? SvgPicture.asset(AppIc.favStar)
                    : SvgPicture.asset(AppIc.favStarNot),
              ),
            ));
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      elevation: 1.5,
      shadowColor: AppColors.layer1,
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            Strings.favoriteTitle,
            textAlign: TextAlign.center,
            style: AppStyles.textHeader,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _getBackButton(context),
          )
        ],
      ),
    );
  }

  Widget _getBackButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16),
        child: SizedBox(
          height: 38,
          width: 38,
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset(AppIc.back)),
        ),
      );
}
