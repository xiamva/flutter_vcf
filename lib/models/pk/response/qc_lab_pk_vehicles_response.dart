import 'package:json_annotation/json_annotation.dart';

part 'qc_lab_pk_vehicles_response.g.dart';

@JsonSerializable()
class QcLabPkVehiclesResponse {
  final bool? success;
  final String? message;
  final List<QcLabPkVehicle>? data;
  final int? total;

  QcLabPkVehiclesResponse({
    this.success,
    this.message,
    this.data,
    this.total,
  });

  factory QcLabPkVehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$QcLabPkVehiclesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QcLabPkVehiclesResponseToJson(this);
}

@JsonSerializable()
class QcLabPkVehicle {
  @JsonKey(name: "registration_id")
  final String? registrationId;

  @JsonKey(name: "wb_ticket_no")
  final String? wbTicketNo;

  @JsonKey(name: "plate_number")
  final String? plateNumber;

  @JsonKey(name: "driver_name")
  final String? driverName;

  @JsonKey(name: "vendor_code")
  final String? vendorCode;

  @JsonKey(name: "vendor_name")
  final String? vendorName;

  @JsonKey(name: "commodity_code")
  final String? commodityCode;

  @JsonKey(name: "commodity_name")
  final String? commodityName;

  @JsonKey(name: "transporter_name")
  final String? transporterName;

  @JsonKey(name: "regist_status")
  final String? registStatus;

  @JsonKey(name: "unloading_status")
  final String? unloadingStatus;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "bruto_weight")
  final String? brutoWeight;

  @JsonKey(name: "vendor_ffa")
  final String? vendorFfa;

  @JsonKey(name: "vendor_moisture")
  final String? vendorMoisture;

  @JsonKey(name: 'lab_status')
  final String? labStatus;

  @JsonKey(name: 'is_relab')
  final bool? isRelab;

  @JsonKey(name: 'counter')
  final int? counter;


  QcLabPkVehicle({
    this.registrationId,
    this.wbTicketNo,
    this.plateNumber,
    this.driverName,
    this.vendorCode,
    this.vendorName,
    this.commodityCode,
    this.commodityName,
    this.transporterName,
    this.registStatus,
    this.unloadingStatus,
    this.createdAt,
    this.brutoWeight,
    this.vendorFfa,
    this.vendorMoisture,
    this.counter,
    this.isRelab,
    this.labStatus,
  });

  factory QcLabPkVehicle.fromJson(Map<String, dynamic> json) =>
      _$QcLabPkVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$QcLabPkVehicleToJson(this);
}
