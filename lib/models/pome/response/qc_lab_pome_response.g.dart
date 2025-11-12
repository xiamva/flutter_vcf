// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_lab_pome_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcLabPomeResponse _$QcLabPomeResponseFromJson(Map<String, dynamic> json) =>
    QcLabPomeResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      total: (json['total'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => QcLabPomeVehicle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QcLabPomeResponseToJson(QcLabPomeResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'total': instance.total,
      'data': instance.data,
    };
