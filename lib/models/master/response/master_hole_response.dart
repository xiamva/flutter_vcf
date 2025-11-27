import 'package:json_annotation/json_annotation.dart';
part 'master_hole_response.g.dart';

@JsonSerializable()
class MasterHoleResponse {
  final bool success;
  final String? message;
  final List<HoleItem> data;

  MasterHoleResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory MasterHoleResponse.fromJson(Map<String, dynamic> json) =>
      _$MasterHoleResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MasterHoleResponseToJson(this);
}

@JsonSerializable()
class HoleItem {
  final int id;
  final String hole_code;
  final String hole_name;

  HoleItem({
    required this.id,
    required this.hole_code,
    required this.hole_name,
  });

  factory HoleItem.fromJson(Map<String, dynamic> json) =>
      _$HoleItemFromJson(json);
  Map<String, dynamic> toJson() => _$HoleItemToJson(this);
}
