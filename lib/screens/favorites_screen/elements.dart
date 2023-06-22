part of 'favorite_screen.dart';

const favoriteTitleText = Text(
  Strings.favoriteTitle,
  textAlign: TextAlign.center,
  style: AppStyles.textHeader,
);

const noFavoritesText = Center(
    child: Text(
  Strings.noFavorites,
  textAlign: TextAlign.center,
  style: AppStyles.textHolder,
));

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
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

class SavedFavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavoriteBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: bloc.state.repos.length,
        itemBuilder: (BuildContext context, int index) {
          var isFavourite = bloc.state.repos[index].isFav;
          return Card(
              color: AppColors.layer1,
              elevation: 0,
              shadowColor: Colors.blue,
              margin: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  bloc.state.repos[index].name,
                  style: AppStyles.textBody,
                ),
                trailing: InkWell(
                  onTap: () {
                    bloc.add(FavoriteSelectedEvent(index: index));
                  },
                  child: isFavourite
                      ? SvgPicture.asset(AppIc.favStar)
                      : SvgPicture.asset(AppIc.favStarNot),
                ),
              ));
        },
      ),
    );
  }
}
