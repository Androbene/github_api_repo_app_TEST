import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/app_ic.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/styles.dart';
import '../bloc/search_block.dart';
import '../bloc/search_events.dart';

class FoundReposList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SearchBloc>(context);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: bloc.state.repos.length,
      itemBuilder: (BuildContext context, int index) {
        var isFavourite = bloc.state.repos[index].isFav;
        return Card(
            color: AppColors.layer1,
            elevation: 0,
            shadowColor: Colors.blue,
            margin: const EdgeInsets.all(5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                bloc.state.repos[index].name,
                style: AppStyles.textBody,
              ),
              trailing: InkWell(
                onTap: () {
                  bloc.add(SearchSelectedEvent(index: index));
                },
                child: isFavourite
                    ? SvgPicture.asset(AppIc.favStar)
                    : SvgPicture.asset(AppIc.favStarNot),
              ),
            ));
      },
    );
  }
}
