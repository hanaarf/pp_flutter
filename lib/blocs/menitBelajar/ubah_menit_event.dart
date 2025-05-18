abstract class UbahMenitEvent {}

class SubmitUbahMenit extends UbahMenitEvent {
  final int menit;

  SubmitUbahMenit(this.menit);
}
