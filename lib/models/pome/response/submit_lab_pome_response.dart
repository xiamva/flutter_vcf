import 'package:json_annotation/json_annotation.dart';

part 'submit_lab_pome_response.g.dart';

@JsonSerializable()
class SubmitLabPomeResponse {
  final bool success;
  final String? message;

  SubmitLabPomeResponse({
    required this.success,
    this.message,
  });

  factory SubmitLabPomeResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitLabPomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitLabPomeResponseToJson(this);
}
