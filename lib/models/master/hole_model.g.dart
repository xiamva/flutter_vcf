// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hole_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HoleModel _$HoleModelFromJson(Map<String, dynamic> json) => HoleModel(
  id: (json['id'] as num).toInt(),
  hole_code: json['hole_code'] as String,
  hole_name: json['hole_name'] as String,
);

Map<String, dynamic> _$HoleModelToJson(HoleModel instance) => <String, dynamic>{
  'id': instance.id,
  'hole_code': instance.hole_code,
  'hole_name': instance.hole_name,
};
