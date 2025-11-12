// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_cpo_vehicles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingCpoVehiclesResponse _$QcSamplingCpoVehiclesResponseFromJson(
  Map<String, dynamic> json,
) => QcSamplingCpoVehiclesResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => QcSamplingCpoVehicle.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QcSamplingCpoVehiclesResponseToJson(
  QcSamplingCpoVehiclesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

QcSamplingCpoVehicle _$QcSamplingCpoVehicleFromJson(
  Map<String, dynamic> json,
) => QcSamplingCpoVehicle(
  registration_id: json['registration_id'] as String?,
  wb_ticket_no: json['wb_ticket_no'] as String?,
  plate_number: json['plate_number'] as String?,
  driver_name: json['driver_name'] as String?,
  vendor_code: json['vendor_code'] as String?,
  vendor_name: json['vendor_name'] as String?,
  commodity_code: json['commodity_code'] as String?,
  commodity_name: json['commodity_name'] as String?,
  regist_status: json['regist_status'] as String?,
  has_sampling_data: json['has_sampling_data'] as bool?,
);

Map<String, dynamic> _$QcSamplingCpoVehicleToJson(
  QcSamplingCpoVehicle instance,
) => <String, dynamic>{
  'registration_id': instance.registration_id,
  'wb_ticket_no': instance.wb_ticket_no,
  'plate_number': instance.plate_number,
  'driver_name': instance.driver_name,
  'vendor_code': instance.vendor_code,
  'vendor_name': instance.vendor_name,
  'commodity_code': instance.commodity_code,
  'commodity_name': instance.commodity_name,
  'regist_status': instance.regist_status,
  'has_sampling_data': instance.has_sampling_data,
};
