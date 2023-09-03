import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/services/api_service.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:http/http.dart' as http;

class KanaService {
  final Isar _isar = locator<Isar>();
  final ApiService _apiService = locator<ApiService>();

  /// Get all the kana related to the group ids given in parameter.
  Future<List<Kana>> getByGroupIds(List<int> groupIds) async {
    if (groupIds.isEmpty) {
      return Future.value(_isar.kanas.where().findAll());
    }

    var kanaQuery = _isar.kanas.where().groupIdEqualTo(groupIds[0]);

    for (var i = 1; i < groupIds.length; i++) {
      kanaQuery = kanaQuery.or().groupIdEqualTo(groupIds[i]);
    }

    final kanas = kanaQuery.findAll();

    if (kanas.isEmpty) {
      deleteAll();
      return loadCollection()
          .then((_) => kanaQuery.findAll())
          .then((value) async {
        return value;
      });
    }

    return Future.value(kanas);
  }

  /// Get all the kana related to the group id given in parameter.
  Future<List<Kana>> getByGroupId(int groupId) async {
    return getByGroupIds([groupId]);
  }

  /// Delete all the kana.
  void deleteAll() {
    _isar.write((isar) => {isar.kanas.where().deleteAll()});
  }

  /// Load all the kana from the API.
  Future<dynamic> loadCollection() {
    return _apiService
        .get('/v1/kanas')
        .then((response) => _extractKanas(response))
        .then((listKana) => _isar.write((isar) => isar.kanas.putAll(listKana)) );
  }

  /// Extract all the kana from the API Response.
  List<Kana> _extractKanas(http.Response response) {
    if (response.statusCode == 200) {
      List<Kana> kanas = [];
      var listKana = jsonDecode(response.body);
      for (final k in listKana) {
        kanas.add(Kana.fromJson(k));
      }
      return kanas;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return List.empty();
    }
  }
}
