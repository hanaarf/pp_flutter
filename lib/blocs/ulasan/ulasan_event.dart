abstract class UlasanEvent {}

class KirimUlasanEvent extends UlasanEvent {
  final String deskripsi;

  KirimUlasanEvent(this.deskripsi);
}
