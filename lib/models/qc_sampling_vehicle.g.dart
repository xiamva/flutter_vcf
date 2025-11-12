// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingVehicle _$QcSamplingVehicleFromJson(Map<String, dynamic> json) =>
    QcSamplingVehicle(
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

Map<String, dynamic> _$QcSamplingVehicleToJson(QcSamplingVehicle instance) =>
    <String, dynamic>{
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
