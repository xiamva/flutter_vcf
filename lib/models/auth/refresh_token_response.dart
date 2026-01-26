import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';

@JsonSerializable()
class RefreshTokenResponse {
  final bool success;
  final String? message;
  final RefreshTokenData? data;

  RefreshTokenResponse({required this.success, this.message, this.data});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}

@JsonSerializable()
class RefreshTokenData {
  final String? token;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'expires_at')
  final String? expiresAt;
  final RefreshTokenUser? user;

  RefreshTokenData({this.token, this.tokenType, this.expiresAt, this.user});

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenDataToJson(this);
}

@JsonSerializable()
class RefreshTokenUser {
  @JsonKey(name: 'user_id')
  final String? userId;
  final String? username;
  final List<String>? roles;

  RefreshTokenUser({this.userId, this.username, this.roles});

  factory RefreshTokenUser.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenUserFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenUserToJson(this);
}
