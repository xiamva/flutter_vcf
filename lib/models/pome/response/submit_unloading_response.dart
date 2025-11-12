import 'package:json_annotation/json_annotation.dart';

part 'submit_unloading_response.g.dart';

@JsonSerializable()
class SubmitUnloadingResponse {
  final bool success;
  final String? message;
  final SubmitUnloadingData? data;

  SubmitUnloadingResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory SubmitUnloadingResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitUnloadingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitUnloadingResponseToJson(this);
}

@JsonSerializable()
class SubmitUnloadingData {
  final String? registration_id;
  final String? unloading_status;
  final String? updated_at;

  SubmitUnloadingData({
    this.registration_id,
    this.unloading_status,
    this.updated_at,
  });

  factory SubmitUnloadingData.fromJson(Map<String, dynamic> json) =>
      _$SubmitUnloadingDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitUnloadingDataToJson(this);
}
