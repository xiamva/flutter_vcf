import 'package:json_annotation/json_annotation.dart';

part 'submit_unloading_response.g.dart';

@JsonSerializable()
class SubmitUnloadingResponse {
  final bool success;
  final String? message;

  SubmitUnloadingResponse({
    required this.success,
    this.message,
  });

  factory SubmitUnloadingResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitUnloadingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitUnloadingResponseToJson(this);
}
