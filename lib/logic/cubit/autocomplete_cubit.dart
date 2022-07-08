import 'package:autocomplete_app/data/model/suggestion.dart';
import 'package:autocomplete_app/data/repositories/autocomplete_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'autocomplete_state.dart';

class AutocompleteCubit extends Cubit<AutocompleteState> {
  AutocompleteCubit(
    this._autocompleteRepo,
  ) : super(const AutocompleteState());

  final AutocompleteRepo _autocompleteRepo;
  bool debouncing = false;

  Future<void> get(final String query) async {
    debouncing = true;
    emit(
      state.copyWith(
        status: AutocompleteStatus.loading,
        query: query,
      ),
    );
    try {
      final suggestions = await _autocompleteRepo.get(
        query: query,
        lang: 'ru',
        limit: 100,
      );

      emit(
        state.copyWith(
          status: AutocompleteStatus.success,
          suggestions: suggestions,
        ),
      );
    } catch (e, s) {
      print(e);
      print(s);
      emit(
        state.copyWith(
          status: AutocompleteStatus.failed,
        ),
      );
    }
  }
}
