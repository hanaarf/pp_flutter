abstract class UbahProfileEvent {}

class SubmitUbahProfile extends UbahProfileEvent {
  final String name;
  final int jenjangId;
  final int kelasId;

  SubmitUbahProfile(this.name, this.jenjangId, this.kelasId);
}
