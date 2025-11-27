// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_pk_vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingPkVehicle _$QcSamplingPkVehicleFromJson(Map<String, dynamic> json) =>
    QcSamplingPkVehicle(
      registration_id: json['registration_id'] as String?,
      wb_ticket_no: json['wb_ticket_no'] as String?,
      plate_number: json['plate_number'] as String?,
      driver_name: json['driver_name'] as String?,
      vendor_code: json['vendor_code'] as String?,
      vendor_name: json['vendor_name'] as String?,
      commodity_code: json['commodity_code'] as String?,
      commodity_name: json['commodity_name'] as String?,
      transporter_name: json['transporter_name'] as String?,
      regist_status: json['regist_status'] as String?,
      has_sampling_data: json['has_sampling_data'] as bool?,
      is_resampling: json['is_resampling'] as bool?,
      bruto_weight: json['bruto_weight'] as num?,
      vendor_ffa: json['vendor_ffa'] as num?,
      vendor_moisture: json['vendor_moisture'] as num?,
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
  'has_sampling_data': instance.has_sampling_data,
  'is_resampling': instance.is_resampling,
  'bruto_weight': instance.bruto_weight,
  'vendor_ffa': instance.vendor_ffa,
  'vendor_moisture': instance.vendor_moisture,
  'created_at': instance.created_at,
};
