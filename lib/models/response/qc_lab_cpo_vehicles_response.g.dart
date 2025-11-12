// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_lab_cpo_vehicles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcLabCpoVehiclesResponse _$QcLabCpoVehiclesResponseFromJson(
  Map<String, dynamic> json,
) => QcLabCpoVehiclesResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => QcLabCpoVehicle.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QcLabCpoVehiclesResponseToJson(
  QcLabCpoVehiclesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
