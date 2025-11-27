import 'package:json_annotation/json_annotation.dart';

part 'unloading_pk_model.g.dart';

@JsonSerializable()
class UnloadingPkModel {
  @JsonKey(name: "registration_id")
  final String? registrationId;

  @JsonKey(name: "process_id")
  final String? processId;

  @JsonKey(name: "plate_number")
  final String? plateNumber;

  @JsonKey(name: "wb_ticket_no")
  final String? wbTicketNo;

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

  @JsonKey(name: "commodity_type")
  final String? commodityType;

  @JsonKey(name: "transporter_name")
  final String? transporterName;

  @JsonKey(name: "regist_status")
  final String? registStatus;

  @JsonKey(name: "unloading_id")
  final String? unloadingId;

  @JsonKey(name: "unloading_status")
  final String? unloadingStatus;

  @JsonKey(name: "tank_id")
  final int? tankId;

  @JsonKey(name: "tank_code")
  final String? tankCode;

  @JsonKey(name: "tank_name")
  final String? tankName;

  @JsonKey(name: "hole_id")
  final int? holeId;

  @JsonKey(name: "hole_code")
  final String? holeCode;

  @JsonKey(name: "hole_name")
  final String? holeName;

  @JsonKey(name: "start_time")
  final String? startTime;

  @JsonKey(name: "end_time")
  final String? endTime;

  @JsonKey(name: "duration_minutes")
  final int? durationMinutes;

  @JsonKey(name: "operator_id")
  final String? operatorId;

  @JsonKey(name: "has_unloading_data")
  final bool? hasUnloadingData;

  @JsonKey(name: "vendor_ffa")
  final String? vendorFfa;

  @JsonKey(name: "vendor_moisture")
  final String? vendorMoisture;

  @JsonKey(name: "bruto_weight")
  final String? brutoWeight;

  UnloadingPkModel({
    this.registrationId,
    this.processId,
    this.plateNumber,
    this.wbTicketNo,
    this.driverName,
    this.vendorCode,
    this.vendorName,
    this.commodityCode,
    this.commodityName,
    this.commodityType,
    this.transporterName,
    this.registStatus,
    this.unloadingId,
    this.unloadingStatus,
    this.tankId,
    this.tankCode,
    this.tankName,
    this.holeId,
    this.holeCode,
    this.holeName,
    this.startTime,
    this.endTime,
    this.durationMinutes,
    this.operatorId,
    this.hasUnloadingData,
    this.vendorFfa,
    this.vendorMoisture,
    this.brutoWeight,
  });

  factory UnloadingPkModel.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPkModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPkModelToJson(this);
}
