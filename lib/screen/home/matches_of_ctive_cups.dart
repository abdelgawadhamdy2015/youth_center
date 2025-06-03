import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
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
  int selectedCenterIndex=0;


  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    final youthCentersAsync = ref.watch(youthCentersProvider);
    final youthCenterNames = youthCentersAsync.asData?.value.map((center) => center.name).toList();
    final selectedyouthCenterName =
        ref.watch(selectedCenterNameProvider) ??
        MyConstants.centerUser?.youthCenterName;
    selectedCenterIndex = (selectedyouthCenterName != null && youthCenterNames != null)
        ? youthCenterNames.indexOf(selectedyouthCenterName)
        : 0;
    final matches = ref.watch(matchesProvider);
    var lang = S.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
         if (!isAdmin)
          youthCentersAsync.when(
            data: (data) {
              final youthCenterNames =
                  data.map((center) => center.name).toList();
              if (data.isEmpty) {
                return Center(child: Text(S.of(context).noData));
              }
              return SizedBox(
              height: SizeConfig.screenHeight! *.05,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: youthCenterNames.length,
                  itemBuilder: (context, index) {
                
                    return GestureDetector(
                      onTap: () {
                          setState(() {
                      selectedCenterIndex = index;
                      ref.watch(selectedCenterNameProvider.notifier).state= youthCenterNames[index];
                    });
                      },
                      child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: selectedCenterIndex == index 
                            ? const Color(0xFF1E40AF)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        youthCenterNames[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: selectedCenterIndex == index 
                              ? Colors.white 
                              : Colors.black,
                        ),
                      ),
                                        ),
                    );
                  },
                ),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text("حدث خطأ: $error")),
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
