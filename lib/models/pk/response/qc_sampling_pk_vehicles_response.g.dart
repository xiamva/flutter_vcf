// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_pk_vehicles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingPkVehiclesResponse _$QcSamplingPkVehiclesResponseFromJson(
  Map<String, dynamic> json,
) => QcSamplingPkVehiclesResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => QcSamplingPkVehicle.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$QcSamplingPkVehiclesResponseToJson(
  QcSamplingPkVehiclesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'total': instance.total,
};

QcSamplingPkVehicle _$QcSamplingPkVehicleFromJson(Map<String, dynamic> json) =>
    QcSamplingPkVehicle(
      registration_id: json['registration_id'] as String,
      wb_ticket_no: json['wb_ticket_no'] as String,
      plate_number: json['plate_number'] as String,
      driver_name: json['driver_name'] as String,
      vendor_code: json['vendor_code'] as String,
      vendor_name: json['vendor_name'] as String,
      commodity_code: json['commodity_code'] as String,
      commodity_name: json['commodity_name'] as String,
      transporter_name: json['transporter_name'] as String,
      regist_status: json['regist_status'] as String,
      wb_in_tap_out: json['wb_in_tap_out'] as String?,
      has_sampling_data: json['has_sampling_data'] as bool,
      is_resampling: json['is_resampling'] as bool,
      bruto_weight: json['bruto_weight'] as String?,
      vendor_ffa: json['vendor_ffa'] as String?,
      vendor_moisture: json['vendor_moisture'] as String?,
      created_at: json['created_at'] as String?,
    );

Map<String, dynamic> _$QcSamplingPkVehicleToJson(
  QcSamplingPkVehicle instance,
) => <String, dynamic>{
  'registration_id': instance.registration_id,
  'wb_ticket_no': instance.wb_ticket_no,
  'plate_number': instance.plate_number,
  'driver_name': instance.driver_name,
  'vendor_code': instance.vendor_code,
  'vendor_name': instance.vendor_name,
  'commodity_code': instance.commodity_code,
  'commodity_name': instance.commodity_name,
  'transporter_name': instance.transporter_name,
  'regist_status': instance.regist_status,
  'wb_in_tap_out': instance.wb_in_tap_out,
  'has_sampling_data': instance.has_sampling_data,
  'is_resampling': instance.is_resampling,
  'bruto_weight': instance.bruto_weight,
  'vendor_ffa': instance.vendor_ffa,
  'vendor_moisture': instance.vendor_moisture,
  'created_at': instance.created_at,
};
