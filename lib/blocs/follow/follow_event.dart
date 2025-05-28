abstract class FollowEvent {}

class CheckFollowStatus extends FollowEvent {
  final int userId;
  CheckFollowStatus(this.userId);
}

class FollowUser extends FollowEvent {
  final int userId;
  FollowUser(this.userId);
}

class UnfollowUser extends FollowEvent {
  final int userId;
  UnfollowUser(this.userId);
}