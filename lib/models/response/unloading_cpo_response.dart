import 'package:flutter_vcf/models/unloading_cpo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unloading_cpo_response.g.dart';

@JsonSerializable()
class UnloadingCPOResponse {
  final bool success;
  final String? message;
  final List<UnloadingCpoModel>? data;
  final int? total;

  UnloadingCPOResponse({
    required this.success,
    this.message,
    this.data,
    this.total,
  });

  factory UnloadingCPOResponse.fromJson(Map<String, dynamic> json) =>
      _$UnloadingCPOResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingCPOResponseToJson(this);
}
