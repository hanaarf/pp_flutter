abstract class LatihanSoalEvent {}

class FetchLatihanSoal extends LatihanSoalEvent {
  final int materiId;
  FetchLatihanSoal(this.materiId);
}
