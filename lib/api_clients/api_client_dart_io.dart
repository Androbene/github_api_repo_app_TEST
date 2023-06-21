import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../models/git_repo.dart';
import '../repository/favorites_repository.dart';

const perPage = 5;

class ApiClientDartIo {
  final client = HttpClient()..connectionTimeout = const Duration(minutes: 1);

  Future<dynamic> getMappedRepos(String searchString) async {
    try {
      final url = _getUrl(searchString);
      final request = await client.getUrl(url);
      final HttpClientResponse response =
          await request.close().timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        // HttpClientResponse has Stream<List<int>> - it's our BODY
        // utf8.decoder - transforms stream Bytes to stream Strings
        final jsonStrings = await response.transform(utf8.decoder).toList();
        final jsonString = jsonStrings.join();
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final rawDataRepos = json['items']
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
    } on TimeoutException catch (e) {
      return e.runtimeType.toString();
    } on SocketException catch (e) {
      return e.runtimeType.toString();
    } catch (e) {
      return e.runtimeType.toString();
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
