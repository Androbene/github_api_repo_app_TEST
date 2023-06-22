import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_ic.dart';
import '../../../constants/route_names.dart';
import '../bloc/search_block.dart';
import '../bloc/search_events.dart';

class FavButton extends StatelessWidget {
  const FavButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await Navigator.pushNamed(context, Routes.favorite);
            BlocProvider.of<SearchBloc>(context).add(SearchRefreshEvent());
          },
          icon: SvgPicture.asset(AppIc.favourite)),
    );
  }
}
