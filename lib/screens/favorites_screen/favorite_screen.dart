import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Widget _buildFullList() {
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
      surfaceTintColor: AppColors.main,
      backgroundColor: AppColors.main,
      elevation: 1.5,
      shadowColor: AppColors.layer1,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(AppIc.back)),
      title: const Center(
        child: Text(
          Strings.favoriteTitle,
          textAlign: TextAlign.center,
          style: AppStyles.textHeader,
        ),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.main,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}
