import 'package:flutter_bloc/flutter_bloc.dart';
import 'materi_event.dart';
import 'materi_state.dart';
import '../../repositories/materi_repository.dart';

class MateriBloc extends Bloc<MateriEvent, MateriState> {
  final MateriRepository repository;

  MateriBloc({required this.repository}) : super(MateriInitial()) {
    on<FetchMateriVideos>((event, emit) async {
      emit(MateriLoading());
      try {
        final videos = await repository.getMateriVideos();
        emit(MateriLoaded(videos));
      } catch (e) {
        emit(MateriError(e.toString()));
      }
    });
  }
}
