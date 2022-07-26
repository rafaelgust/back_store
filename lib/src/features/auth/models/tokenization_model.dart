// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TokenizationModel {
  final String accessToken;
  final String refreshToken;

  TokenizationModel({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  factory TokenizationModel.fromMap(Map<String, dynamic> map) {
    return TokenizationModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenizationModel.fromJson(String source) =>
      TokenizationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
