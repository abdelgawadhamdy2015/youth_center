
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/core/service/data_base_service.dart';
import 'package:youth_center/screen/home/home_controller.dart';
import 'package:youth_center/screen/home/match_card.dart';

class MatchesOfActiveCups extends ConsumerStatefulWidget {
  const MatchesOfActiveCups({super.key});

  @override
  ConsumerState<MatchesOfActiveCups> createState() => _MatchesState();
}

class _MatchesState extends ConsumerState<MatchesOfActiveCups> {
  final DataBaseService bookingService = DataBaseService();

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    final youthCentersAsync = ref.watch(youthCentersProvider);
    final selectedyouthCenterName = ref.watch(selectedCenterNameProvider);
    final matches = ref.watch(matchesProvider);
    var lang = S.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!isAdmin)
            youthCentersAsync.when(
              data: (centers) {
                final centerNames = centers.map((e) => e.name).toSet().toList();
                return DayDropdown(
                  lableText: S.of(context).selectCenter,
                  days: centerNames,
                  selectedDay: selectedyouthCenterName,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        ref.read(selectedCenterNameProvider.notifier).state =
                            value;
                      });
                    }
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(child: Text(error.toString()));
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
            ),

          HelperMethods.verticalSpace(.02),

          matches.when(
            data: (data) {
              if (data.isEmpty) {
                return Center(
                  child: Text(
                    lang.NoMatches,
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final match = data[index];
                  return InteractiveMatchCard(
                    canUpdate: false,
                    match: match,
                    isAdmin: isAdmin,
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return Center(child: Text(error.toString()));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
