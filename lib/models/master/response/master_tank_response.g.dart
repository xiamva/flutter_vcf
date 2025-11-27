// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_tank_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterTankResponse _$MasterTankResponseFromJson(Map<String, dynamic> json) =>
    MasterTankResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => TankItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MasterTankResponseToJson(MasterTankResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

TankItem _$TankItemFromJson(Map<String, dynamic> json) => TankItem(
  id: (json['id'] as num).toInt(),
  tank_code: json['tank_code'] as String,
  tank_name: json['tank_name'] as String,
);

Map<String, dynamic> _$TankItemToJson(TankItem instance) => <String, dynamic>{
  'id': instance.id,
  'tank_code': instance.tank_code,
  'tank_name': instance.tank_name,
};
