import 'package:json_annotation/json_annotation.dart';

part 'lab_pk_detail_response.g.dart';

@JsonSerializable()
class LabPkDetailResponse {
  final bool? success;
  final String? message;
  final LabPkDetailData? data;

  LabPkDetailResponse({this.success, this.message, this.data});

  factory LabPkDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$LabPkDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LabPkDetailResponseToJson(this);
}

@JsonSerializable()
class LabPkDetailData {
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

  @JsonKey(name: "has_lab_data")
  final bool? hasLabData;

  @JsonKey(name: "lab_records")
  final List<LabPkRecord>? labRecords;

  @JsonKey(name: "lab_count")
  final int? labCount;

  @JsonKey(name: "vendor_ffa")
  final String? vendorFfa;

  @JsonKey(name: "vendor_moisture")
  final String? vendorMoisture;

  LabPkDetailData({
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
    this.hasLabData,
    this.labRecords,
    this.labCount,
    this.vendorFfa,
    this.vendorMoisture,
  });

  factory LabPkDetailData.fromJson(Map<String, dynamic> json) =>
      _$LabPkDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$LabPkDetailDataToJson(this);
}

@JsonSerializable()
class LabPkRecord {
  @JsonKey(name: "lab_id")
  final String? labId;

  final int? counter;
  final String? ffa;
  final String? moisture;
  final String? dirt;

  @JsonKey(name: "oil_content")
  final String? oilContent;

  final String? remarks;
  final String? status;

  @JsonKey(name: "tested_at")
  final String? testedAt;

  @JsonKey(name: "tested_by")
  final String? testedBy;

  @JsonKey(name: "photos")
  final List<LabPkPhoto>? photos;

  @JsonKey(name: "photos_count")
  final int? photosCount;

  LabPkRecord({
    this.labId,
    this.counter,
    this.ffa,
    this.moisture,
    this.dirt,
    this.oilContent,
    this.remarks,
    this.status,
    this.testedAt,
    this.testedBy,
    this.photos,
    this.photosCount,
  });

  factory LabPkRecord.fromJson(Map<String, dynamic> json) =>
      _$LabPkRecordFromJson(json);

  Map<String, dynamic> toJson() => _$LabPkRecordToJson(this);
}

@JsonSerializable()
class LabPkPhoto {
  @JsonKey(name: "photo_id")
  final String? photoId;

  final int? sequence;
  final String? path;
  final String? url;

  @JsonKey(name: "taken_at")
  final String? takenAt;

  LabPkPhoto({
    this.photoId,
    this.sequence,
    this.path,
    this.url,
    this.takenAt,
  });

  factory LabPkPhoto.fromJson(Map<String, dynamic> json) =>
      _$LabPkPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$LabPkPhotoToJson(this);
}
