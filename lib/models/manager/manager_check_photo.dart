import 'package:json_annotation/json_annotation.dart';

part 'manager_check_photo.g.dart';

@JsonSerializable()
class ManagerCheckPhoto {
  final String? photo_id;
  final int? photo_sequence;
  final String? photo_data;

  ManagerCheckPhoto({
    this.photo_id,
    this.photo_sequence,
    this.photo_data,
  });

  factory ManagerCheckPhoto.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckPhotoFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerCheckPhotoToJson(this);
}
