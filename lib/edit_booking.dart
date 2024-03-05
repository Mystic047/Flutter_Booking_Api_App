import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.encode
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class BookingEditPage extends StatefulWidget {
  final int userId, bookingId, roomId;
  late double totalPrice;
  final String checkInDate, checkOutDate, status;

  BookingEditPage({
    Key? key,
    required this.bookingId,
    required this.userId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.status,
  }) : super(key: key);

  @override
  State<BookingEditPage> createState() => _BookingEditPageState();
}

class _BookingEditPageState extends State<BookingEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bookingIdController,
      _userIdController,
      _roomIdController,
      _checkInDateController,
      _checkOutDateController,
      _totalPriceController,
      _statusController;

  @override
  void initState() {
    super.initState();
    _bookingIdController = TextEditingController(text: widget.bookingId.toString());
    _userIdController = TextEditingController(text: widget.userId.toString());
    _roomIdController = TextEditingController(text: widget.roomId.toString());
    _checkInDateController = TextEditingController(text: formatDateString(widget.checkInDate));
    _checkOutDateController = TextEditingController(text: formatDateString(widget.checkOutDate));
    _totalPriceController = TextEditingController(text: widget.totalPrice.toString());
    _statusController = TextEditingController(text: widget.status);
  }

  String formatDateString(String dateString) {
    var parsedDate = DateTime.parse(dateString);
    var formatter = DateFormat('yyyy-MM-dd'); // Use any format that suits your need
    return formatter.format(parsedDate);
  }

  Future<void> _editBooking(
      int bookingId,
      int userId,
      int roomId,
      String checkInDate,
      String checkOutDate,
      double totalPrice,
      String status) async {
    if (kDebugMode) {
      print('Updating Booking with ID: $bookingId');
    }
    var url = Uri.parse('http://localhost:3000/api_update/updateBooking/$bookingId');

    try {
      var response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'booking_id': bookingId,
          'user_id': userId,
          'room_id': roomId,
          'check_in_date': checkInDate,
          'check_out_date': checkOutDate,
          'total_price': totalPrice,
          'status': status,
        }),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Booking updated successfully.');
        }
        // Optionally, refresh the UI or user list here if needed
      } else {
        if (kDebugMode) {
          print('Failed to update Booking data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating Booking data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Booking'),
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _bookingIdController,
                      decoration: const InputDecoration(labelText: 'Booking ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Booking ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _userIdController,
                      decoration: const InputDecoration(labelText: 'User ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the User ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _roomIdController,
                      decoration: const InputDecoration(labelText: 'Room ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Room ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _checkInDateController,
                      decoration: const InputDecoration(labelText: 'Check-In Date'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Check-In Date';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _checkOutDateController,
                      decoration: const InputDecoration(labelText: 'Check-Out Date'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Check-Out Date';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _totalPriceController,
                      decoration: const InputDecoration(labelText: 'Total Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Total Price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _statusController,
                      decoration: const InputDecoration(labelText: 'Status'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the status';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Parsing values before calling the update function
                          int bookingId = int.parse(_bookingIdController.text);
                          int userId = int.parse(_userIdController.text);
                          int roomId = int.parse(_roomIdController.text);
                          String checkInDate = _checkInDateController.text;
                          String checkOutDate = _checkOutDateController.text;
                          double totalPrice = double.parse(_totalPriceController.text);
                          String status = _statusController.text;

                          _editBooking(
                              bookingId, userId, roomId, checkInDate, checkOutDate, totalPrice, status);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
