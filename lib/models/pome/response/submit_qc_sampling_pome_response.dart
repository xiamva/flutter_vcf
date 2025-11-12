import 'package:json_annotation/json_annotation.dart';

part 'submit_qc_sampling_pome_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SubmitQcSamplingPomeResponse {
  final bool success;
  final String? message;
  final PomeSamplingData? data;

  SubmitQcSamplingPomeResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory SubmitQcSamplingPomeResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitQcSamplingPomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitQcSamplingPomeResponseToJson(this);
}

@JsonSerializable()
class PomeSamplingData {
  final String? sampling_id;
  final String? process_id;
  final String? registration_id;
  final String? plate_number;
  final String? wb_ticket_no;
  final String? vendor_code;
  final String? vendor_name;
  final double? sediment_level;
  final double? ph_value;
  final String? sampled_at;
  final String? sampled_by;
  final List<PomePhoto>? photos;

  PomeSamplingData({
    this.sampling_id,
    this.process_id,
    this.registration_id,
    this.plate_number,
    this.wb_ticket_no,
    this.vendor_code,
    this.vendor_name,
    this.sediment_level,
    this.ph_value,
    this.sampled_at,
    this.sampled_by,
    this.photos,
  });

  factory PomeSamplingData.fromJson(Map<String, dynamic> json) =>
      _$PomeSamplingDataFromJson(json);

  Map<String, dynamic> toJson() => _$PomeSamplingDataToJson(this);
}

@JsonSerializable()
class PomePhoto {
  final String? photo_id;
  final int? sequence;
  final String? path;
  final String? url;

  PomePhoto({
    this.photo_id,
    this.sequence,
    this.path,
    this.url,
  });

  factory PomePhoto.fromJson(Map<String, dynamic> json) =>
      _$PomePhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PomePhotoToJson(this);
}
