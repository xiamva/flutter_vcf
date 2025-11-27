import 'package:json_annotation/json_annotation.dart';
part 'master_tank_response.g.dart';

@JsonSerializable()
class MasterTankResponse {
  final bool success;
  final String? message;
  final List<TankItem> data;

  MasterTankResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory MasterTankResponse.fromJson(Map<String, dynamic> json) =>
      _$MasterTankResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MasterTankResponseToJson(this);
}

@JsonSerializable()
class TankItem {
  final int id;
  final String tank_code;
  final String tank_name;

  TankItem({
    required this.id,
    required this.tank_code,
    required this.tank_name,
  });

  factory TankItem.fromJson(Map<String, dynamic> json) =>
      _$TankItemFromJson(json);
  Map<String, dynamic> toJson() => _$TankItemToJson(this);
}
