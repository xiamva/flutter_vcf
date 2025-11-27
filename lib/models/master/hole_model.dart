import 'package:json_annotation/json_annotation.dart';

part 'hole_model.g.dart';

@JsonSerializable()
class HoleModel {
  final int id;
  final String hole_code;
  final String hole_name;

  HoleModel({
    required this.id,
    required this.hole_code,
    required this.hole_name,
  });

  factory HoleModel.fromJson(Map<String, dynamic> json) =>
      _$HoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$HoleModelToJson(this);
}
