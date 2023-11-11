import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'vocabulary.g.dart';

@collection
@Name("Vocabulary")
@JsonSerializable()
class Vocabulary {
  final int id;

  /// Contains the vocabulary word entirely even if it is a mix of kana and kanji.
  final String kanji;
  /// Full kana version of the word
  final String kana;
  @JsonKey(name: "niveau_jlpt")
  final int jlptLevel;
  /// Translations and meaning of the word
  @Default([])
  final List<String> meanings;
  final String romaji;
  @Default([])
  @JsonKey(name: "related_kanjis")
  final List<int>? relatedKanjis;
  final String version;

  Vocabulary(this.id, this.kanji, this.kana, this.niveauJLPT,
      this.significations, this.romaji, this.relatedKanjis, this.version);

  factory Vocabulary.fromJson(Map<String, dynamic> json) =>
      _$VocabularyFromJson(json);
}
