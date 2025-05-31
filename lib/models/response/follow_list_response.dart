import 'package:pp_flutter/models/response/user_follow_response.dart';

class FollowListResponse {
  final int count;
  final List<UserFollow> data;

  FollowListResponse({required this.count, required this.data});

  factory FollowListResponse.fromJson(Map<String, dynamic> json) =>
      FollowListResponse(
        count: json['count'] ?? 0,
        data:
            (json['data'] as List).map((e) => UserFollow.fromJson(e)).toList(),
      );
}
