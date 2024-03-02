import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_booking/ForUser/user_review_page.dart';
import 'package:flutter_app_booking/login.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: duplicate_import
import 'package:flutter_app_booking/session.dart';

class UserBookingDataPage extends StatefulWidget {
  const UserBookingDataPage({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserBookingDataPage(),
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _UserBookingDataPageState createState() => _UserBookingDataPageState();
}

class _UserBookingDataPageState extends State<UserBookingDataPage> {
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
        title: const Text('Booking Hotel App'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleMenuClick,
            itemBuilder: (BuildContext context) {
              return {'Review', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
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
                  child: Column(
                    children: [
                      // Image from assets
                      Image.asset(
                        'assets/images/room.jpg', // Path to your sample image
                        width: double
                            .infinity, // Make the image take the full width of the card
                        height: 200, // Fixed height for the image
                        fit: BoxFit.cover, // Cover the entire width of the card
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Room ID: ${room['room_id']}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8.0),
                            Text('Price: ${room['price']}',
                                style: const TextStyle(fontSize: 16.0)),
                            const SizedBox(height: 8.0),
                            Text('Amenities: ${room['amenities']}',
                                style: const TextStyle(fontSize: 16.0)),
                          ],
                        ),
                      ),
                      // Button at the bottom right
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 12.0, bottom: 12.0),
                            child: ElevatedButton(
                              onPressed: () => _bookRoom(
                                room['room_id'].toString(),
                                room['price'].toString(),
                              ),
                              child: const Text('Book'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void handleMenuClick(String value) {
    switch (value) {
      case 'Review':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserHoteldataPage(),
          ),
        );
        break;
      case 'Logout':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const Login()), // Assuming your login page is called "Login"
          (Route<dynamic> route) =>
              false, // Conditions that returns false, so it removes all routes
        );
        break;
      default:
        break;
    }
  }
}
