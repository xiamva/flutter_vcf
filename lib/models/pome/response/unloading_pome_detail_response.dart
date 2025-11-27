import 'package:json_annotation/json_annotation.dart';

part 'unloading_pome_detail_response.g.dart';

@JsonSerializable()
class UnloadingPomeDetailResponse {
  final bool success;
  final String message;
  final UnloadingPomeDetail? data;

  UnloadingPomeDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UnloadingPomeDetailResponse.fromJson(Map<String, dynamic> json)
      => _$UnloadingPomeDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPomeDetailResponseToJson(this);
}

@JsonSerializable()
class UnloadingPomeDetail {
  final String? registration_id;
  final String? process_id;
  final String? plate_number;
  final String? wb_ticket_no;
  final String? driver_name;
  final String? vendor_code;
  final String? vendor_name;
  final String? commodity_code;
  final String? commodity_name;
  final String? commodity_type;
  final String? transporter_name;
  final String? regist_status;

  @JsonKey(name: "unloading_id")
  final String? unloadingId;

  @JsonKey(name: "tank_id", fromJson: _toInt)
  final int? tankId;

  final String? tank_code;
  final String? tank_name;

  @JsonKey(name: "hole_id", fromJson: _toInt)
  final int? holeId;

  final String? hole_code;
  final String? hole_name;

  @JsonKey(name: "unloading_status")
  final String? unloadingStatus;

  final String? remarks;

  final String? start_time;
  final String? end_time;

  @JsonKey(name: "operator_id", fromJson: _toInt)
  final int? operatorId;

  final bool? has_unloading_data;

  @JsonKey(name: "duration_minutes", fromJson: _toDouble)
  final double? durationMinutes;

  @JsonKey(name: "vendor_ffa", fromJson: _toDouble)
  final double? vendorFfa;

  @JsonKey(name: "vendor_moisture", fromJson: _toDouble)
  final double? vendorMoisture;

  @JsonKey(name: "bruto_weight", fromJson: _toDouble)
  final double? brutoWeight;

  final List<PomeUnloadingPhoto>? photos;

  UnloadingPomeDetail({
    this.registration_id,
    this.process_id,
    this.plate_number,
    this.wb_ticket_no,
    this.driver_name,
    this.vendor_code,
    this.vendor_name,
    this.commodity_code,
    this.commodity_name,
    this.commodity_type,
    this.transporter_name,
    this.regist_status,
    this.unloadingId,
    this.tankId,
    this.tank_code,
    this.tank_name,
    this.holeId,
    this.hole_code,
    this.hole_name,
    this.unloadingStatus,
    this.remarks,
    this.start_time,
    this.end_time,
    this.operatorId,
    this.has_unloading_data,
    this.durationMinutes,
    this.vendorFfa,
    this.vendorMoisture,
    this.brutoWeight,
    this.photos,
  });

  factory UnloadingPomeDetail.fromJson(Map<String, dynamic> json)
      => _$UnloadingPomeDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPomeDetailToJson(this);

  // ========= SAFE PARSERS =========

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}

@JsonSerializable()
class PomeUnloadingPhoto {
  final String? url;
  final String? path;

  PomeUnloadingPhoto({
    this.url,
    this.path,
  });

  factory PomeUnloadingPhoto.fromJson(Map<String, dynamic> json)
      => _$PomeUnloadingPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PomeUnloadingPhotoToJson(this);
}
