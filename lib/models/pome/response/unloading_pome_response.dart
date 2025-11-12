import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_vcf/models/pome/unloading_pome_model.dart';

part 'unloading_pome_response.g.dart';

@JsonSerializable()
class UnloadingPOMEResponse {
  final bool? success;
  final String? message;
  final List<UnloadingPomeModel>? data;

  UnloadingPOMEResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UnloadingPOMEResponse.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPOMEResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPOMEResponseToJson(this);
}
