abstract class UbahMenitState {}

class UbahMenitInitial extends UbahMenitState {}

class UbahMenitLoading extends UbahMenitState {}

class UbahMenitSuccess extends UbahMenitState {}

class UbahMenitFailure extends UbahMenitState {
  final String message;

  UbahMenitFailure(this.message);
}
