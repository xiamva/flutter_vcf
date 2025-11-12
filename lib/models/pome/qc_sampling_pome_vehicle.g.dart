// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_pome_vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingPomeVehicle _$QcSamplingPomeVehicleFromJson(
  Map<String, dynamic> json,
) => QcSamplingPomeVehicle(
  registrationId: json['registration_id'] as String?,
  wbTicketNo: json['wb_ticket_no'] as String?,
  plateNumber: json['plate_number'] as String?,
  driverName: json['driver_name'] as String?,
  vendorCode: json['vendor_code'] as String?,
  vendorName: json['vendor_name'] as String?,
  commodityCode: json['commodity_code'] as String?,
  commodityName: json['commodity_name'] as String?,
  transporterName: json['transporter_name'] as String?,
  registStatus: json['regist_status'] as String?,
  hasSamplingData: json['has_sampling_data'] as bool?,
);

Map<String, dynamic> _$QcSamplingPomeVehicleToJson(
  QcSamplingPomeVehicle instance,
) => <String, dynamic>{
  'registration_id': instance.registrationId,
  'wb_ticket_no': instance.wbTicketNo,
  'plate_number': instance.plateNumber,
  'driver_name': instance.driverName,
  'vendor_code': instance.vendorCode,
  'vendor_name': instance.vendorName,
  'commodity_code': instance.commodityCode,
  'commodity_name': instance.commodityName,
  'transporter_name': instance.transporterName,
  'regist_status': instance.registStatus,
  'has_sampling_data': instance.hasSamplingData,
};
