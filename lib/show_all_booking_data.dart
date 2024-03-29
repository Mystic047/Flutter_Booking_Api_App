import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_booking.dart';
import 'package:intl/intl.dart';

class BookingdataPageShow extends StatefulWidget {
  const BookingdataPageShow({Key? key}) : super(key: key);

  @override
  State<BookingdataPageShow> createState() => _BookingdataPageShowState();
}

class _BookingdataPageShowState extends State<BookingdataPageShow> {
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
            'Failed to load booking data with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching booking data: $e');
    }
  }

  Future<void> _deleteBooking(int bookingID) async {
    var url = Uri.parse(
        'http://localhost:3000/api_delete/deleteBooking?booking_id=$bookingID');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        debugPrint('Booking deleted successfully');
        setState(() {
          _booking.removeWhere((booking) => booking['booking_id'] == bookingID);
        });
      } else {
        debugPrint(
            'Failed to delete booking with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting booking: $e');
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
        title: const Text('All Booking Data'),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding around the list for spacing
          child: ListView.builder(
            itemCount: _booking.length,
            itemBuilder: (context, index) {
              var bookings = _booking[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Add spacing between each card
                child: Container(
                  color: Colors.white.withOpacity(0.8), // Semi-transparent overlay
                  child: ListTile(
                    title: Text(
                        'Booking ID : ${bookings['booking_id']} User ID : ${bookings['user_id']} Room ID :${bookings['room_id']}'),
                    subtitle: Text(
                        'check in date : ${formatDateString(bookings['check_in_date'])} check out date : ${formatDateString(bookings['check_out_date'])}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BookingEditPage(
                                  bookingId: bookings['booking_id'],
                                  userId: bookings['user_id'],
                                  roomId: bookings['room_id'],
                                  checkInDate: bookings['check_in_date'],
                                  checkOutDate: bookings['check_out_date'],
                                  totalPrice: bookings['total_price'] != null
                                      ? bookings['total_price'].toDouble()
                                      : 0.0,
                                  status: bookings['status'],
                                ),
                              ),
                            );
                            _fetchbookingData(); // Refresh the entire list
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteBooking(bookings['booking_id']),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
