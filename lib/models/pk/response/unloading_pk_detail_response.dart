import 'package:json_annotation/json_annotation.dart';

part 'unloading_pk_detail_response.g.dart';

@JsonSerializable()
class UnloadingPkDetailResponse {
  final bool? success;
  final String? message;
  final UnloadingPkDetailData? data;

  UnloadingPkDetailResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UnloadingPkDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPkDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPkDetailResponseToJson(this);
}

@JsonSerializable()
class UnloadingPkDetailData {
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

  @JsonKey(name: "unloading_status")
  final String? unloadingStatus;

  final String? remarks;

  @JsonKey(name: "start_time")
  final String? startTime;

  @JsonKey(name: "end_time")
  final String? endTime;

  @JsonKey(name: "operator_id")
  final String? operatorId;

  @JsonKey(name: "has_unloading_data")
  final bool? hasUnloadingData;

  @JsonKey(name: "duration_minutes")
  final int? durationMinutes;

  @JsonKey(name: "vendor_ffa")
  final String? vendorFfa;

  @JsonKey(name: "vendor_moisture")
  final String? vendorMoisture;

  @JsonKey(name: "bruto_weight")
  final String? brutoWeight;

  final List<UnloadingPkPhoto>? photos;

  UnloadingPkDetailData({
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
    this.tankId,
    this.tankCode,
    this.tankName,
    this.holeId,
    this.holeCode,
    this.holeName,
    this.unloadingStatus,
    this.remarks,
    this.startTime,
    this.endTime,
    this.operatorId,
    this.hasUnloadingData,
    this.durationMinutes,
    this.vendorFfa,
    this.vendorMoisture,
    this.brutoWeight,
    this.photos,
  });

  factory UnloadingPkDetailData.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPkDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPkDetailDataToJson(this);
}

@JsonSerializable()
class UnloadingPkPhoto {
  @JsonKey(name: "photo_id")
  final String? photoId;

  final int? sequence;
  final String? path;
  final String? url;

  @JsonKey(name: "taken_at")
  final String? takenAt;

  UnloadingPkPhoto({
    this.photoId,
    this.sequence,
    this.path,
    this.url,
    this.takenAt,
  });

  factory UnloadingPkPhoto.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPkPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPkPhotoToJson(this);
}
