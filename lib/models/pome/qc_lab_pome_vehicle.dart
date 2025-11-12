import 'package:json_annotation/json_annotation.dart';

part 'qc_lab_pome_vehicle.g.dart';

@JsonSerializable()
class QcLabPomeVehicle {
  @JsonKey(name: 'registration_id')
  final String? registrationId;

  @JsonKey(name: 'wb_ticket_no')
  final String? wbTicketNo;

  @JsonKey(name: 'plate_number')
  final String? plateNumber;

  @JsonKey(name: 'driver_name')
  final String? driverName;

  @JsonKey(name: 'vendor_code')
  final String? vendorCode;

  @JsonKey(name: 'vendor_name')
  final String? vendorName;

  @JsonKey(name: 'commodity_code')
  final String? commodityCode;

  @JsonKey(name: 'commodity_name')
  final String? commodityName;

  @JsonKey(name: 'transporter_name')
  final String? transporterName;

  @JsonKey(name: 'regist_status')
  final String? registStatus;

  @JsonKey(name: 'lab_status')
  final String? labStatus;

  @JsonKey(name: 'bruto_weight')
  final String? brutoWeight;

  @JsonKey(name: 'vendor_ffa')
  final String? vendorFfa;

  @JsonKey(name: 'vendor_moisture')
  final String? vendorMoisture;

  QcLabPomeVehicle({
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
    this.labStatus,
    this.brutoWeight,
    this.vendorFfa,
    this.vendorMoisture,
  });

  factory QcLabPomeVehicle.fromJson(Map<String, dynamic> json) =>
      _$QcLabPomeVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$QcLabPomeVehicleToJson(this);
}
