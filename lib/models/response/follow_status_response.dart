class FollowStatusResponse {
  final bool followed;

  FollowStatusResponse({required this.followed});

  factory FollowStatusResponse.fromJson(Map<String, dynamic> json) =>
      FollowStatusResponse(followed: json['followed'] == true);
}