import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pp_flutter/blocs/detailMateri/detail_event.dart';
import 'package:pp_flutter/blocs/detailMateri/detail_state.dart';
import 'package:pp_flutter/repositories/materi_repository.dart';

class MateriDetailBloc extends Bloc<MateriDetailEvent, MateriDetailState> {
  final MateriRepository repository;

  MateriDetailBloc({required this.repository}) : super(MateriDetailInitial()) {
    on<FetchMateriDetail>((event, emit) async {
      emit(MateriDetailLoading());
      try {
        final materi = await repository.getMateriDetail(event.id);
        emit(MateriDetailLoaded(materi));
      } catch (e) {
        emit(MateriDetailError(e.toString()));
      }
    });
  }
}
