class FollowRequest {
  final int followingId;

  FollowRequest(this.followingId);

  Map<String, dynamic> toJson() => {'following_id': followingId};
}