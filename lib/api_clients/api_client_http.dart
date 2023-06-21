import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/git_repo.dart';
import '../repository/favorites_repository.dart';

const perPage = 15;
const timeout = Duration(minutes: 1);

class ApiClientHttp {
  Future<dynamic> getMappedRepos(String searchString) async {
    try {
      final url = _getUrl(searchString);
      final response = await http.get(url).timeout(timeout);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final rawDataRepos = data['items']
            .map((item) => GitRepo(
                  item['html_url'] as String,
                  item['name'] as String,
                  false,
                ))
            .toList();

        final List<GitRepo> dataReposMappedFromStorage = [];
        for (var raw in rawDataRepos) {
          dataReposMappedFromStorage.add(GitRepo(
            raw.url,
            raw.name,
            await FavoritesRepository().isFavourite(raw),
          ));
        }
        return dataReposMappedFromStorage;
      } else {
        return response.reasonPhrase;
      }
    } catch (error) {
      return error.toString();
    }
  }

  Uri _getUrl(String searchString) {
    return Uri(
      scheme: 'https',
      host: 'api.github.com',
      path: 'search/repositories',
      queryParameters: {
        'q': searchString,
        'sort': 'stars',
        'order': 'desc',
        'per_page': perPage.toString()
      },
    );
  }
}
