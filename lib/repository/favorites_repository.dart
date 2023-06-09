import 'package:github_api_repo_app/models/fav_repo.dart';
import 'package:github_api_repo_app/models/git_repo.dart';
import 'package:hive/hive.dart';

class FavoritesRepository {
  static final FavoritesRepository _singleton = FavoritesRepository._internal();

  factory FavoritesRepository() => _singleton;

  FavoritesRepository._internal() {
    Hive.registerAdapter(FavRepoAdapter());
  }

  static const _name = "FavRepoBoxName";

  Future<List<FavRepo>> getAll() async =>
      (await Hive.openBox<FavRepo>(_name)).values.toList();

  Future<void> insert(GitRepo repo) async =>
      (await Hive.openBox<FavRepo>(_name))
          .put(repo.url, FavRepo(repo.url, repo.name));

  Future<void> remove(GitRepo repo) async =>
      (await Hive.openBox<FavRepo>(_name)).delete(repo.url);

  Future<bool> isFavourite(GitRepo repo) async =>
      (await Hive.openBox<FavRepo>(_name))
          .values
          .toList()
          .map((e) => e.url)
          .contains(repo.url);

  void closeRepo() => Hive.box<FavRepo>(_name).close();
}
