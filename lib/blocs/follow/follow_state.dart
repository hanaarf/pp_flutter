abstract class FollowState {}

class FollowInitial extends FollowState {}

class FollowLoading extends FollowState {}

class FollowLoaded extends FollowState {
  final bool isFollowing;
  FollowLoaded(this.isFollowing);
}

class FollowError extends FollowState {
  final String message;
  FollowError(this.message);
}