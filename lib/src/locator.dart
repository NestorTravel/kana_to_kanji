import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:kana_to_kanji/src/core/dataloaders/group_dataloader.dart';
import 'package:kana_to_kanji/src/core/dataloaders/kana_dataloader.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';
import 'package:kana_to_kanji/src/core/models/kana.dart';
import 'package:kana_to_kanji/src/core/repositories/groups_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/kana_repository.dart';
import 'package:kana_to_kanji/src/core/repositories/settings_repository.dart';
import 'package:kana_to_kanji/src/core/services/api_service.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/core/services/preferences_service.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Logger>(() => Logger());

  // Services
  locator.registerLazySingleton<PreferencesService>(() => PreferencesService());
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerSingletonAsync<InfoService>(() async {
    final instance = InfoService();
    await instance.initialize();
    return instance;
  });

  // Isar
  locator.registerSingletonAsync<Isar>(() async {
    await Isar.initialize();
    final String directory = kIsWeb
        ? Isar.sqliteInMemory
        : (await getApplicationSupportDirectory()).path;

    var isar = Isar.open(
      schemas: [GroupSchema, KanaSchema],
      directory: directory,
      engine: IsarEngine.sqlite,
    );

    return isar;
  });

  // Repositories
  locator.registerSingletonWithDependencies<GroupsRepository>(
      () => GroupsRepository(),
      dependsOn: [Isar]);
  locator.registerSingletonWithDependencies<KanaRepository>(
      () => KanaRepository(),
      dependsOn: [Isar]);
  locator.registerSingleton<SettingsRepository>(SettingsRepository());

  // Data Loaders
  locator.registerSingletonWithDependencies<GroupDataLoader>(
      () => GroupDataLoader(),
      dependsOn: [Isar]);
  locator.registerSingletonWithDependencies<KanaDataLoader>(
      () => KanaDataLoader(),
      dependsOn: [Isar]);
}
