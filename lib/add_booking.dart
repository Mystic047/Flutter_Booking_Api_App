import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: duplicate_import
import 'session.dart';

class BookingDataPage extends StatefulWidget {
  const BookingDataPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingDataPageState createState() => _BookingDataPageState();
}

class _BookingDataPageState extends State<BookingDataPage> {
  List<Map<String, dynamic>> _rooms = []; // Placeholder for rooms data
  final checkInDateController = TextEditingController();
  final checkOutDateController = TextEditingController();

  Future<void> _fetchAvailableRooms() async {
    if (checkInDateController.text.isEmpty ||
        checkOutDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both check-in and check-out dates.')),
      );
      return;
    }

    final Uri url = Uri.parse('http://localhost:3000/api_fetch/rooms/available')
        .replace(queryParameters: {
      'check_in_date': checkInDateController.text,
      'check_out_date': checkOutDateController.text,
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _rooms = List<Map<String, dynamic>>.from(
              json.decode(response.body)['availableRooms']);
        });
      } else {
        debugPrint(
            'Failed to load available rooms with status code: ${response.statusCode}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to load available rooms: ${json.decode(response.body)['message']}')),
        );
      }
    } catch (e) {
      debugPrint('Error fetching available rooms: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching available rooms.')),
      );
    }
  }

  Future<void> _bookRoom(String roomId, String price) async {
    final url = Uri.parse('http://localhost:3000/api_add/createBooking');
    if (kDebugMode) {
      print(Session.userID);
      print(roomId);
      print(checkInDateController.text);
      print(checkOutDateController.text);
      print(price);
    }
    final bookingData = {
      'user_id': Session.userID,
      'room_id': roomId,
      'check_in_date': checkInDateController.text,
      'check_out_date': checkOutDateController.text,
      'total_price': price,
      'status': 'reserved', // Default status
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bookingData),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      _fetchAvailableRooms();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Booking successful!')));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to book the room.')));
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Room'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: checkInDateController,
                      decoration: const InputDecoration(
                        labelText: 'Check-in Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        await _selectDate(context, checkInDateController);
                        if (checkInDateController.text.isNotEmpty &&
                            checkOutDateController.text.isNotEmpty) {
                          await _fetchAvailableRooms();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      controller: checkOutDateController,
                      decoration: const InputDecoration(
                        labelText: 'Check-out Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        await _selectDate(context, checkOutDateController);
                        if (checkInDateController.text.isNotEmpty &&
                            checkOutDateController.text.isNotEmpty) {
                          await _fetchAvailableRooms();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Placeholder for room list, replace with your actual room list fetching logic
            ListView.builder(
              shrinkWrap: true,
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                final room = _rooms[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  child: ListTile(
                    title: Text('Room ID: ${room['room_id']}'),
                    subtitle: Text('Price: ${room['price']}'),
                    trailing: ElevatedButton(
                      onPressed: () => _bookRoom(
                          room['room_id'].toString(), room['price'].toString()),
                      child: const Text('Book'),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
