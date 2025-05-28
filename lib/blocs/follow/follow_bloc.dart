import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/repositories/follow_repository.dart';
import 'follow_event.dart';
import 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final FollowRepository repository;

  FollowBloc(this.repository) : super(FollowInitial()) {
    on<CheckFollowStatus>((event, emit) async {
      emit(FollowLoading());
      try {
        final isFollowing = await repository.isFollowing(event.userId);
        emit(FollowLoaded(isFollowing));
      } catch (e) {
        emit(FollowError(e.toString()));
      }
    });

    on<FollowUser>((event, emit) async {
      emit(FollowLoading());
      try {
        await repository.follow(event.userId);
        emit(FollowLoaded(true));
      } catch (e) {
        emit(FollowError(e.toString()));
      }
    });

    on<UnfollowUser>((event, emit) async {
      emit(FollowLoading());
      try {
        await repository.unfollow(event.userId);
        emit(FollowLoaded(false));
      } catch (e) {
        emit(FollowError(e.toString()));
      }
    });
  }
}