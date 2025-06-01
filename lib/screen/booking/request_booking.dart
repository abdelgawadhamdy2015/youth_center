import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestBookingScreen extends ConsumerStatefulWidget {
  const RequestBookingScreen({super.key});

  @override
  ConsumerState<RequestBookingScreen> createState() =>
      _RequestBookingScreenState();
}

class _RequestBookingScreenState extends ConsumerState<RequestBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Booking'),
      ),
      body: Center(
        child: Text('Booking Form Goes Here'),
      ),
    );
  }
}