import 'package:json_annotation/json_annotation.dart';

part 'submit_qc_sampling_response.g.dart';

@JsonSerializable()
class SubmitQcSamplingResponse {
  final bool success;
  final String? message;
  final CpoSamplingData? data;

  SubmitQcSamplingResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory SubmitQcSamplingResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitQcSamplingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitQcSamplingResponseToJson(this);
}

@JsonSerializable()
class CpoSamplingData {
  @JsonKey(name: 'sampling_id')
  final String? samplingId;

  @JsonKey(name: 'registration_id')
  final String? registrationId;

  @JsonKey(name: 'oil_temp')
  final String? oilTemp;

  @JsonKey(name: 'visual_color')
  final String? visualColor;

  final List<CpoSamplingPhoto>? photos;

  CpoSamplingData({
    this.samplingId,
    this.registrationId,
    this.oilTemp,
    this.visualColor,
    this.photos,
  });

  factory CpoSamplingData.fromJson(Map<String, dynamic> json) =>
      _$CpoSamplingDataFromJson(json);

  Map<String, dynamic> toJson() => _$CpoSamplingDataToJson(this);
}

@JsonSerializable()
class CpoSamplingPhoto {
  final String? url;
  final String? path;
  final int? sequence;

  CpoSamplingPhoto({
    this.url,
    this.path,
    this.sequence,
  });

  factory CpoSamplingPhoto.fromJson(Map<String, dynamic> json) =>
      _$CpoSamplingPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$CpoSamplingPhotoToJson(this);
}
