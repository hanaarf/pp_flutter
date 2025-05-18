abstract class UbahProfileState {}

class UbahProfileInitial extends UbahProfileState {}

class UbahProfileLoading extends UbahProfileState {}

class UbahProfileSuccess extends UbahProfileState {}

class UbahProfileFailure extends UbahProfileState {
  final String message;

  UbahProfileFailure(this.message);
}
