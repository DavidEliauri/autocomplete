import 'package:equatable/equatable.dart';

class Suggestion extends Equatable {
  const Suggestion({
    required this.text,
  });

  final String text;

  factory Suggestion.fromApi(final String text) {
    return Suggestion(
      text: text,
    );
  }

  @override
  List<Object?> get props {
    return [
      text,
    ];
  }
}
