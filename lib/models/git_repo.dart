class GitRepo {
  String url; /// URL is a unique ID of Git repository
  String name;
  bool isFav;

  GitRepo(this.url, this.name, this.isFav);

  @override
  String toString() => '[$name, $url, $isFav]'; // Just for debug
}
