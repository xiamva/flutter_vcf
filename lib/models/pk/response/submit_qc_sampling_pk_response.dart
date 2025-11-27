import 'package:json_annotation/json_annotation.dart';

part 'submit_qc_sampling_pk_response.g.dart';

@JsonSerializable()
class SubmitQcSamplingPkResponse {
  final bool success;
  final String message;
  final SubmitQcSamplingPkData? data;

  SubmitQcSamplingPkResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SubmitQcSamplingPkResponse.fromJson(Map<String, dynamic> json)
      => _$SubmitQcSamplingPkResponseFromJson(json);
}

@JsonSerializable()
class SubmitQcSamplingPkData {
  final String sampling_id;
  final String process_id;
  final String registration_id;
  final String plate_number;
  final String wb_ticket_no;
  final String vendor_code;
  final String vendor_name;
  final num? kernel_dirt;
  final num? oil_content_estimate;
  final int counter;
  final bool is_resampling;
  final String sampled_at;
  final String sampled_by;
  final List<SubmitQcSamplingPkPhoto>? photos;
  final int photos_count;

  SubmitQcSamplingPkData({
    required this.sampling_id,
    required this.process_id,
    required this.registration_id,
    required this.plate_number,
    required this.wb_ticket_no,
    required this.vendor_code,
    required this.vendor_name,
    this.kernel_dirt,
    this.oil_content_estimate,
    required this.counter,
    required this.is_resampling,
    required this.sampled_at,
    required this.sampled_by,
    this.photos,
    required this.photos_count,
  });

  factory SubmitQcSamplingPkData.fromJson(Map<String, dynamic> json)
      => _$SubmitQcSamplingPkDataFromJson(json);
}

@JsonSerializable()
class SubmitQcSamplingPkPhoto {
  final String photo_id;
  final int sequence;
  final String path;
  final String url;

  SubmitQcSamplingPkPhoto({
    required this.photo_id,
    required this.sequence,
    required this.path,
    required this.url,
  });

  factory SubmitQcSamplingPkPhoto.fromJson(Map<String, dynamic> json)
      => _$SubmitQcSamplingPkPhotoFromJson(json);
}