import 'package:json_annotation/json_annotation.dart';
part 'submit_qc_lab_response.g.dart';

@JsonSerializable()
class SubmitQcLabResponse {
  final bool success;
  final String message;

  SubmitQcLabResponse({
    required this.success,
    required this.message,
  });

  factory SubmitQcLabResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitQcLabResponseFromJson(json);
}
