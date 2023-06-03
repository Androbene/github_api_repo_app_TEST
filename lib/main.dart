import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'application.dart';
import 'models/fav_repo_model.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPersistStorages();
  runApp(const GitHubApiApp());
}

Future initPersistStorages() async {
  prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(FavRepoAdapter());
}
