// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_pome_vehicles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingPomeVehiclesResponse _$QcSamplingPomeVehiclesResponseFromJson(
  Map<String, dynamic> json,
) => QcSamplingPomeVehiclesResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => QcSamplingPomeVehicle.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$QcSamplingPomeVehiclesResponseToJson(
  QcSamplingPomeVehiclesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'total': instance.total,
};
