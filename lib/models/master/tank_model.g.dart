// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TankModel _$TankModelFromJson(Map<String, dynamic> json) => TankModel(
  id: (json['id'] as num).toInt(),
  tank_code: json['tank_code'] as String,
  tank_name: json['tank_name'] as String,
);

Map<String, dynamic> _$TankModelToJson(TankModel instance) => <String, dynamic>{
  'id': instance.id,
  'tank_code': instance.tank_code,
  'tank_name': instance.tank_name,
};
