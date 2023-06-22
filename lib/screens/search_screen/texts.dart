part of 'search_screen.dart';

const searchHistoryText = Text(
  Strings.searchHistory,
  style: AppStyles.textHeaderBlue,
  textAlign: TextAlign.left,
);

const whatWeHaveFoundText = Text(
  Strings.whatWeHaveFound,
  style: AppStyles.textHeaderBlue,
  textAlign: TextAlign.left,
);

const nothingWasFoundText = Text(
  Strings.nothingWasFound,
  textAlign: TextAlign.center,
  style: AppStyles.textHolder,
);

const emptyHistoryText = Text(
  Strings.emptyHistory,
  textAlign: TextAlign.center,
  style: AppStyles.textHolder,
);

const searchTitleText = Text(
Strings.searchTitle,
textAlign: TextAlign.center,
style: AppStyles.textHeader,
);

const cupertinoIndicator = Align(
  alignment: Alignment.topCenter,
  child: Padding(
    padding: EdgeInsets.only(top: 22),
    child: CupertinoActivityIndicator(
      color: AppColors.progressCupertino,
      radius: 11.0,
    ),
  ),
);
