import 'package:json_annotation/json_annotation.dart';

part 'tank_model.g.dart';

@JsonSerializable()
class TankModel {
  final int id;
  final String tank_code;
  final String tank_name;

  TankModel({
    required this.id,
    required this.tank_code,
    required this.tank_name,
  });

  factory TankModel.fromJson(Map<String, dynamic> json) =>
      _$TankModelFromJson(json);

  Map<String, dynamic> toJson() => _$TankModelToJson(this);
}
