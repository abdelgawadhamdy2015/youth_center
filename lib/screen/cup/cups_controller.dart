import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/service/data_base_service.dart';
import 'package:youth_center/models/tournament.dart';

final cupsControllerProvider = Provider<CupsController>(
  (ref) => CupsController(ref),
);

class CupsController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  CupsController(this.ref) : super(AsyncValue.data(null));

  Future<void> createCup(Tournament tournament) async {
    state = const AsyncLoading();
    try {
      await DataBaseService().createCup(tournament);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteCup(String cupId) async {
    state = const AsyncLoading();
    try {
      await DataBaseService().deleteCup(cupId);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateCup(Tournament tournament) async {
    state = const AsyncLoading();
    try {
      await DataBaseService().updateCup(tournament);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}
