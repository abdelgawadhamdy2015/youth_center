import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/screen/booking/booking_controller.dart';
import 'package:youth_center/screen/home/home_controller.dart';

class BookingRequestsScreen extends ConsumerStatefulWidget {
  const BookingRequestsScreen({super.key});

  @override
  ConsumerState<BookingRequestsScreen> createState() =>
      _RequestBookingScreenState();
}

class _RequestBookingScreenState extends ConsumerState<BookingRequestsScreen> {
  acceptRequestBooking(BookingModel request) async {
    await ref
        .watch(addBookingProvider.notifier)
        .acceptRequestBooking(request)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).requestAccepted)),
          );

          ref
              .watch(addBookingProvider.notifier)
              .deleteRequestBooking(request)
              .then((value) {
                ref.invalidate(bookingRequestsProvider);
                ref.invalidate(bookingsProvider);
              });
        });
  }

  rejectRequestBooking(BookingModel request) async {
    await ref
        .watch(addBookingProvider.notifier)
        .rejectRequestBooking(request)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).requestRejected)),
          );
          ref
              .watch(addBookingProvider.notifier)
              .deleteRequestBooking(request)
              .then((value) {
                ref.invalidate(bookingRequestsProvider);
                ref.invalidate(bookingsProvider);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final bookingRequestsAsync = ref.watch(bookingRequestsProvider);

    return GradientContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HelperMethods.buildHeader(context, lang.requests, true),
            BodyContainer(
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
                              style: TextStyles.blackBoldStyle(
                                SizeConfig.fontSize3!,
                              ),
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
            ),
          ],
        ),
      ),
    );
  }

  _buildRequestItem(BookingModel request) {
    final lang = S.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.02),
        child: Column(
          children: [
            _buildListTile(
              title: "${lang.name} : ",
              subtitle: request.name.toString(),
            ),
            _buildListTile(
              title: "${lang.bookingDay} : ",
              subtitle: request.day.toString(),
            ),
            _buildListTile(
              title: "${lang.bookingTime} : ",
              subtitle:
                  '${lang.from} ${request.timeStart} - ${lang.to} ${request.timeEnd}',
            ),

            _buildListTile(
              title: "${lang.mobile} : ",
              subtitle: request.mobile.toString(),
            ),
            _buildListTile(
              title: "${lang.requestDate} : ",
              subtitle:
                  "${MyConstants.dateFormat.format(DateTime.parse(request.date))} ",
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButtonText(
                  buttonWidth: SizeConfig.screenWidth! * 0.3,
                  textStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
                  butonText: lang.accept,
                  onPressed: () {
                    acceptRequestBooking(request);
                  },
                ),
                AppButtonText(
                  buttonWidth: SizeConfig.screenWidth! * 0.3,
                  butonText: lang.reject,
                  onPressed: () {
                    rejectRequestBooking(request);
                  },
                  textStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildRequestList(List<BookingModel> requests) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestItem(request);
      },
    );
  }

  _buildListTile({required String title, required String subtitle}) {
    return ListTile(
      minVerticalPadding: SizeConfig.screenHeight! * 0.002,
      minTileHeight: SizeConfig.screenHeight! * 0.01,
      leading: Text(
        title,
        style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
      ),
      title: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: TextStyles.darkBlueBoldStyle(SizeConfig.fontSize3!),
      ),
    );
  }
}
