part of 'autocomplete_cubit.dart';

enum AutocompleteStatus {
  initial,
  loading,
  success,
  failed,
}

extension AutocompleteStatusX on AutocompleteStatus {
  bool get isInitial => this == AutocompleteStatus.initial;
  bool get isLoading => this == AutocompleteStatus.loading;
  bool get isSuccess => this == AutocompleteStatus.success;
  bool get isFailed => this == AutocompleteStatus.failed;
}

class AutocompleteState extends Equatable {
  const AutocompleteState({
    this.status = AutocompleteStatus.initial,
    this.query = '',
    this.suggestions = const [],
  });

  final AutocompleteStatus status;
  final String query;
  final List<Suggestion> suggestions;

  AutocompleteState copyWith({
    final AutocompleteStatus? status,
    final String? query,
    final List<Suggestion>? suggestions,
  }) {
    return AutocompleteState(
      status: status ?? this.status,
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  @override
  List<Object?> get props => [
        status,
        query,
        suggestions,
      ];
}
