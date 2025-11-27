// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_lab_pk_vehicles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcLabPkVehiclesResponse _$QcLabPkVehiclesResponseFromJson(
  Map<String, dynamic> json,
) => QcLabPkVehiclesResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => QcLabPkVehicle.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$QcLabPkVehiclesResponseToJson(
  QcLabPkVehiclesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'total': instance.total,
};

QcLabPkVehicle _$QcLabPkVehicleFromJson(Map<String, dynamic> json) =>
    QcLabPkVehicle(
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
      unloadingStatus: json['unloading_status'] as String?,
      createdAt: json['created_at'] as String?,
      brutoWeight: json['bruto_weight'] as String?,
      vendorFfa: json['vendor_ffa'] as String?,
      vendorMoisture: json['vendor_moisture'] as String?,
      counter: (json['counter'] as num?)?.toInt(),
      isRelab: json['is_relab'] as bool?,
      labStatus: json['lab_status'] as String?,
    );

Map<String, dynamic> _$QcLabPkVehicleToJson(QcLabPkVehicle instance) =>
    <String, dynamic>{
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
      'unloading_status': instance.unloadingStatus,
      'created_at': instance.createdAt,
      'bruto_weight': instance.brutoWeight,
      'vendor_ffa': instance.vendorFfa,
      'vendor_moisture': instance.vendorMoisture,
      'lab_status': instance.labStatus,
      'is_relab': instance.isRelab,
      'counter': instance.counter,
    };
