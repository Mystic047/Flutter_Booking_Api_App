import 'package:flutter/material.dart';
import 'package:flutter_app_booking/ForUser/review_submit_page.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserHoteldataPage extends StatefulWidget {
  const UserHoteldataPage({Key? key}) : super(key: key);

  @override
  State<UserHoteldataPage> createState() => _UserHoteldataPageState();
}

class _UserHoteldataPageState extends State<UserHoteldataPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookings'),
      ),
      body: ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          var booking = _bookings[index];
          return Card(
            child: ListTile(
              title: Text(
                  'Booking ID: ${booking['booking_id']} - Room ID: ${booking['room_id']}'),
              subtitle: Text(
                  'Check-in: ${booking['check_in_date']} - Check-out: ${booking['check_out_date']}'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReviewSubmissionPage(roomId: booking['room_id'])),
                  );
                },
                child: const Text('Review'),
              ),
            ),
          );
        },
      ),
    );
  }
}
