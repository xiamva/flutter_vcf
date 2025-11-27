import 'package:json_annotation/json_annotation.dart';

part 'submit_lab_pk_response.g.dart';

@JsonSerializable()
class SubmitLabPkResponse {
  final bool? success;
  final String? message;

  SubmitLabPkResponse({
    this.success,
    this.message,
  });

  factory SubmitLabPkResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitLabPkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitLabPkResponseToJson(this);
}
