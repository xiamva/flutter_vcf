// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenResponse _$RefreshTokenResponseFromJson(
  Map<String, dynamic> json,
) => RefreshTokenResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RefreshTokenData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RefreshTokenResponseToJson(
  RefreshTokenResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

RefreshTokenData _$RefreshTokenDataFromJson(Map<String, dynamic> json) =>
    RefreshTokenData(
      token: json['token'] as String?,
      tokenType: json['token_type'] as String?,
      expiresAt: json['expires_at'] as String?,
      user: json['user'] == null
          ? null
          : RefreshTokenUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefreshTokenDataToJson(RefreshTokenData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'token_type': instance.tokenType,
      'expires_at': instance.expiresAt,
      'user': instance.user,
    };

RefreshTokenUser _$RefreshTokenUserFromJson(Map<String, dynamic> json) =>
    RefreshTokenUser(
      userId: json['user_id'] as String?,
      username: json['username'] as String?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RefreshTokenUserToJson(RefreshTokenUser instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'roles': instance.roles,
    };
