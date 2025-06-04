import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/core/service/data_base_service.dart';
import 'package:youth_center/models/tournament.dart';

final cupsControllerProvider = Provider<CupsController>(
  (ref) => CupsController(ref),
);

class CupsController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  CupsController(this.ref) : super(AsyncValue.data(null));

  Future<void> createCup(Tournament cup) async {
    state = const AsyncLoading();
    try {
      await DataBaseService().createCup(cup);
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

  Future<void> updateCup(CupModel cup) async {
    state = const AsyncLoading();
    try {
      await DataBaseService().updateCup(cup);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}
