import 'package:flutter/material.dart';
import 'package:flutter_app_booking/ForUser/review_submit_page.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class UserReviewHoteldataPage extends StatefulWidget {
  const UserReviewHoteldataPage({Key? key}) : super(key: key);

  @override
  State<UserReviewHoteldataPage> createState() =>
      _UserReviewHoteldataPageState();
}

class _UserReviewHoteldataPageState extends State<UserReviewHoteldataPage> {
  List<dynamic> _bookings = []; // Changed to bookings

  @override
  void initState() {
    super.initState();
    _fetchBookingData(); // Changed to fetch booking data
  }

  Future<void> _fetchBookingData() async {
    debugPrint('Session ID: ${Session.userID}');
    var url = Uri.parse(
        'http://localhost:3000/api_fetch/api/allbookingdata/${Session.userID}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _bookings = json.decode(response.body);
        });
      } else {
        debugPrint(
            'Failed to load booking data with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching booking data: $e');
    }
  }

  String formatDateString(String dateString) {
    var parsedDate = DateTime.parse(dateString);
    var formatter =
        DateFormat('yyyy-MM-dd'); // Use any format that suits your need
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://chillpainai.com/src/wewakeup/scoop/images/baf655e2658c0a8e0fd2a06cb25a28673ee6c594.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            var booking = _bookings[index];
            bool isReviewed = booking['reviewed'] == 1;

            return Card(
              child: ListTile(
                title: Text(
                    'Booking ID: ${booking['booking_id']} - Room ID: ${booking['room_id']}'),
                subtitle: Text(
                    'Check-in: ${formatDateString(booking['check_in_date'])} - Check-out: ${formatDateString(booking['check_out_date'])}'),
                trailing: ElevatedButton(
                  onPressed: isReviewed
                      ? null
                      : () {
                          // Navigate to review submission page if not reviewed
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewSubmissionPage(
                                      roomId: booking['room_id'])));
                        },
                  style: ElevatedButton.styleFrom(
                    disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    disabledBackgroundColor: Colors.grey
                        .withOpacity(0.12), // Button color when disabled
                  ),
                  child: Text(isReviewed ? 'Reviewed' : 'Review'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
