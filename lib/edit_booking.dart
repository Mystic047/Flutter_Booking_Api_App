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
    _bookingIdController =
        TextEditingController(text: widget.bookingId.toString());
    _userIdController = TextEditingController(text: widget.userId.toString());
    _roomIdController = TextEditingController(text: widget.roomId.toString());
    _checkInDateController =
        TextEditingController(text: formatDateString(widget.checkInDate));
    _checkOutDateController =
        TextEditingController(text: formatDateString(widget.checkOutDate));
    _totalPriceController =
        TextEditingController(text: widget.totalPrice.toString());
    _statusController = TextEditingController(text: widget.status);
  }

  String formatDateString(String dateString) {
    var parsedDate = DateTime.parse(dateString);
    var formatter =
        DateFormat('yyyy-MM-dd'); // Use any format that suits your need
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
    var url =
        Uri.parse('http://localhost:3000/api_update/updateBooking/$bookingId');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'booking_id': bookingId,
          'user_id': userId,
          'room_id': roomId,
          'check_in_date': formatDateString(checkInDate),
          'check_out_date': formatDateString(checkOutDate),
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
          print(
              'Failed to update Booking data with status code: ${response.statusCode}');
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _bookingIdController,
              decoration: const InputDecoration(labelText: 'Booking Id'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an Booking Id';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User Id'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a User Id';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _roomIdController,
              decoration: const InputDecoration(labelText: 'Room Id'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Room Id';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _checkInDateController,
              decoration: const InputDecoration(labelText: 'Check in'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Check in date';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _checkOutDateController,
              decoration: const InputDecoration(labelText: 'Check out'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Check out date';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _totalPriceController,
              decoration: const InputDecoration(labelText: 'Total Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Total Price';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Status';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate form first
                // Validate form first
                if (_formKey.currentState!.validate()) {
                  // Parsing strings to the respective types
                  int userId = int.tryParse(_userIdController.text) ?? 0;
                  int roomId = int.tryParse(_roomIdController.text) ?? 0;
                  double totalPrice =
                      double.tryParse(_totalPriceController.text) ?? 0.0;

                  // Make sure that parsing was successful by checking against default values
                  if (userId == 0 || roomId == 0 || totalPrice == 0.0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please enter valid numbers for User ID, Room ID, and Total Price')),
                    );
                    return;
                  }
                  _editBooking(
                    widget.bookingId,
                    userId,
                    roomId,
                    _checkInDateController.text,
                    _checkOutDateController.text,
                    totalPrice,
                    _statusController.text,
                  ).then((_) {
                    // Handle success or error here, if necessary
                    Navigator.of(context)
                        .pop(); // Assuming you want to pop on success
                  }).catchError((error) {
                    // Handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating Booking: $error')),
                    );
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
