// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_hole_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterHoleResponse _$MasterHoleResponseFromJson(Map<String, dynamic> json) =>
    MasterHoleResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => HoleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MasterHoleResponseToJson(MasterHoleResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

HoleItem _$HoleItemFromJson(Map<String, dynamic> json) => HoleItem(
  id: (json['id'] as num).toInt(),
  hole_code: json['hole_code'] as String,
  hole_name: json['hole_name'] as String,
);

Map<String, dynamic> _$HoleItemToJson(HoleItem instance) => <String, dynamic>{
  'id': instance.id,
  'hole_code': instance.hole_code,
  'hole_name': instance.hole_name,
};
