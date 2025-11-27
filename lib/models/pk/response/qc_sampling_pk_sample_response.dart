import 'package:json_annotation/json_annotation.dart';

part 'qc_sampling_pk_sample_response.g.dart';

@JsonSerializable()
class QcSamplingPkSampleResponse {
  final bool success;
  final String message;
  final QcSamplingPkSampleData? data;

  QcSamplingPkSampleResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QcSamplingPkSampleResponse.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPkSampleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingPkSampleResponseToJson(this);
}

@JsonSerializable()
class QcSamplingPkSampleData {
  final String registration_id;
  final String? process_id;
  final String? plate_number;
  final String? wb_ticket_no;
  final String driver_name;
  final String vendor_code;
  final String vendor_name;
  final String commodity_code;
  final String commodity_name;
  final String commodity_type;
  final String transporter_name;
  final String regist_status;

  final bool has_sampling_data;
  final int sampling_count;
  final List<QcSamplingPkRecord> sampling_records;

  QcSamplingPkSampleData({
    required this.registration_id,
    this.process_id,
    this.plate_number,
    this.wb_ticket_no,
    required this.driver_name,
    required this.vendor_code,
    required this.vendor_name,
    required this.commodity_code,
    required this.commodity_name,
    required this.commodity_type,
    required this.transporter_name,
    required this.regist_status,
    required this.has_sampling_data,
    required this.sampling_count,
    required this.sampling_records,
  });

  factory QcSamplingPkSampleData.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPkSampleDataFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingPkSampleDataToJson(this);
}

@JsonSerializable()
class QcSamplingPkRecord {
  final String sampling_id;
  final int counter;
  final double? kernel_dirt;
  final double? oil_content_estimate;
  final String? sampled_at;
  final String? sampled_by;
  final int photos_count;
  final List<QcSamplingPkPhoto> photos;

  QcSamplingPkRecord({
    required this.sampling_id,
    required this.counter,
    this.kernel_dirt,
    this.oil_content_estimate,
    this.sampled_at,
    this.sampled_by,
    required this.photos_count,
    required this.photos,
  });

  factory QcSamplingPkRecord.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPkRecordFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingPkRecordToJson(this);
}

@JsonSerializable()
class QcSamplingPkPhoto {
  final String photo_id;
  final int sequence;
  final String path;
  final String url;
  final String? taken_at;

  QcSamplingPkPhoto({
    required this.photo_id,
    required this.sequence,
    required this.path,
    required this.url,
    this.taken_at,
  });

  factory QcSamplingPkPhoto.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPkPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingPkPhotoToJson(this);
}
