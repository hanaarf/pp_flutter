abstract class MateriDetailEvent {}

class FetchMateriDetail extends MateriDetailEvent {
  final int id;

  FetchMateriDetail(this.id);
}
