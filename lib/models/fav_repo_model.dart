import 'package:hive/hive.dart';

class FavRepo {
  String url;
  String name;

  FavRepo(this.url, this.name);

  @override
  String toString() => '[$name, $url]'; // Just for debug
}

class FavRepoAdapter extends TypeAdapter<FavRepo> {
  @override
  final typeId = 0;

  @override
  FavRepo read(BinaryReader reader) {
    return FavRepo(reader.readString(), reader.readString());
  }

  @override
  void write(BinaryWriter writer, FavRepo obj) {
    writer.writeString(obj.url);
    writer.writeString(obj.name);
  }
}
//
// class RepoBox { // constants
//   RepoBox._();
//   static const name = "FavRepoBoxName";
//   // static const url = "RepoBoxUrlKey";
// }
