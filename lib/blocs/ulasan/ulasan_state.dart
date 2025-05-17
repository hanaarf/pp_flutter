abstract class UlasanState {}

class UlasanInitial extends UlasanState {}

class UlasanLoading extends UlasanState {}

class UlasanSuccess extends UlasanState {}

class UlasanFailure extends UlasanState {
  final String message;

  UlasanFailure(this.message);
}
