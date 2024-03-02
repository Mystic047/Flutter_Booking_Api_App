import 'package:flutter/material.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart'; // For using json.decode

class ReportBookingDataPage extends StatefulWidget {
  const ReportBookingDataPage({Key? key}) : super(key: key);

  @override
  State<ReportBookingDataPage> createState() => _ReportBookingDataPageState();
}

class _ReportBookingDataPageState extends State<ReportBookingDataPage> {
  List<dynamic> _booking = [];

  @override
  void initState() {
    super.initState();
    _fetchbookingData();
  }

  Future<void> _fetchbookingData() async {
    var url = Uri.parse('http://localhost:3000/api_fetch/allbookingdata');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _booking = json.decode(response.body);
        });
      } else {
        debugPrint(
            'Failed to load hotel data with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching hotel data: $e');
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
        title: Text(Session.firstName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/22/25/ce/ea/kingsford-hotel-manila.jpg?w=1200&h=-1&s=1'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _booking.length,
          itemBuilder: (context, index) {
            var book = _booking[index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
                  // Handle tap if necessary, for example, to view detailed user profile
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Id : ${book['booking_id'].toString()} ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.hotel,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Room Id: ${book['room_id'].toString()} '
                              'User Id: ${book['user_id'].toString()} ', // Assuming 'first_name' is the field name
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.login,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(
                                  ' Check in date : ${formatDateString(book['check_in_date'])}')),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.logout,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(
                                  ' Check out date : ${formatDateString(book['check_out_date'])}')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
