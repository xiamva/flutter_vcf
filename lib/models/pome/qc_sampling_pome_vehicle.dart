import 'package:json_annotation/json_annotation.dart';
part 'qc_sampling_pome_vehicle.g.dart';

@JsonSerializable()
class QcSamplingPomeVehicle {
  @JsonKey(name: "registration_id")
  String? registrationId;

  @JsonKey(name: "wb_ticket_no")
  String? wbTicketNo;

  @JsonKey(name: "plate_number")
  String? plateNumber;

  @JsonKey(name: "driver_name")
  String? driverName;

  @JsonKey(name: "vendor_code")
  String? vendorCode;

  @JsonKey(name: "vendor_name")
  String? vendorName;

  @JsonKey(name: "commodity_code")
  String? commodityCode;

  @JsonKey(name: "commodity_name")
  String? commodityName;

  @JsonKey(name: "transporter_name")
  String? transporterName;

  @JsonKey(name: "regist_status")
  String? registStatus;

  @JsonKey(name: "has_sampling_data")
  bool? hasSamplingData;

  QcSamplingPomeVehicle({
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
    this.hasSamplingData,
  });

  factory QcSamplingPomeVehicle.fromJson(Map<String, dynamic> json)
      => _$QcSamplingPomeVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingPomeVehicleToJson(this);
}
