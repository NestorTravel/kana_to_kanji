import 'package:flutter/foundation.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/kana_service.dart';

class KanaRepository {
  late final KanaService _kanaService;
  @visibleForTesting
  final List<Kana> kana = [];

  /// [kanaService] should only be used for testing
  KanaRepository({KanaService? kanaService}) {
    _kanaService = kanaService ?? KanaService();
  }

  void loadKana() {
    if (kana.isEmpty) {
      kana.addAll(
          [..._kanaService.getHiragana(), ..._kanaService.getKatakana()]);
    }
  }

  List<Kana> getByGroupIds(List<int> groupIds) {
    loadKana();
    final kanaFiltered =
        kana.where((element) => groupIds.contains(element.groupId)).toList();

    return kanaFiltered;
  }

  List<Kana> getByGroupId(int groupId) {
    return getByGroupIds([groupId]);
  }

  List<Kana> getHiragana() {
    loadKana();
    return kana
        .where((element) => Alphabets.hiragana == element.alphabet)
        .toList();
  }

  List<Kana> searchHiraganaRomaji(String searchTxt) {
    loadKana();
    if (searchTxt.length > 3) {
      return List.empty(growable: false);
    }
    return kana
        .where((element) =>
            Alphabets.hiragana == element.alphabet &&
            element.romaji.contains(searchTxt))
        .toList();
  }

  List<Kana> searchHiraganaKana(String searchTxt) {
    loadKana();
    return kana
        .where((element) =>
            Alphabets.hiragana == element.alphabet &&
            element.kana.contains(searchTxt))
        .toList();
  }

  List<Kana> getKatakana() {
    loadKana();
    return kana
        .where((element) => Alphabets.katakana == element.alphabet)
        .toList();
  }

  List<Kana> searchKatakanaRomaji(String searchTxt) {
    loadKana();
    if (searchTxt.length > 3) {
      return List.empty(growable: false);
    }
    return kana
        .where((element) =>
            Alphabets.katakana == element.alphabet &&
            element.romaji.contains(searchTxt))
        .toList();
  }

  List<Kana> searchKatakanaKana(String searchTxt) {
    loadKana();
    return kana
        .where((element) =>
            Alphabets.katakana == element.alphabet &&
            element.kana.contains(searchTxt))
        .toList();
  }
}
