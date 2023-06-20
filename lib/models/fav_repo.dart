import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fav_repo.g.dart';

@JsonSerializable()
class FavRepo {
  @JsonKey(name: 'html_url')
  String url;
  @JsonKey(name: 'name')
  String name;

  FavRepo(this.url, this.name);

  factory FavRepo.fromJson(Map<String, dynamic> json) =>
      _$FavRepoFromJson(json);

  Map<String, dynamic> toJson(n) => _$FavRepoToJson(this);

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
