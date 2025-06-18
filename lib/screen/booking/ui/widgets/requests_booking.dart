import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/screen/booking/logic/booking_controller.dart';
import 'package:youth_center/screen/booking/ui/widgets/request_card.dart';
import 'package:youth_center/screen/home/logic/home_controller.dart';

class BookingRequestsScreen extends ConsumerStatefulWidget {
  const BookingRequestsScreen({super.key});

  @override
  ConsumerState<BookingRequestsScreen> createState() =>
      _RequestBookingScreenState();
}

class _RequestBookingScreenState extends ConsumerState<BookingRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final bookingRequestsAsync = ref.watch(bookingRequestsProvider);

    return BodyContainer(
      height: SizeConfig.screenHeight! * 0.8,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: bookingRequestsAsync.when(
                data: (requests) {
                  if (requests.isEmpty) {
                    return Text(
                      lang.noData,
                      style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
                    );
                  }
                  return _buildRequestList(requests);
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Text(error.toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildRequestList(List<BookingModel> requests) {
    final isAdmin = ref.watch(isAdminProvider);
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return RequestCard(request: request, isAdmin: isAdmin);
      },
    );
  }
}
