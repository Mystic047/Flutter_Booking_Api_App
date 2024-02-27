import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_booking/add_booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'show_all_user_data.dart';
import 'add_hotel.dart';
import 'add_room.dart';
import 'register.dart';
import 'show_all_hotel_data.dart';
import 'show_all_room_data.dart';
import 'session.dart'; // Import session.dart

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'Loading...';
  @override
  void initState() {
    super.initState();
    fetchUserData(widget.email);
  }

  Future<void> fetchUserData(String email) async {
    if (kDebugMode) {
      print('Fetching user data for email: $email');
    }
    var queryParams = {'email': email};
    var queryString = Uri(queryParameters: queryParams).query;
    var url = Uri.parse(
        'http://localhost:3000/api_fetch/alluserdatabyEmail?$queryString');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> userData = json.decode(response.body);
        if (userData.isNotEmpty) {
          setState(() {
            Session.userID = userData[0]['user_id'].toString();
            Session.firstName = userData[0]['first_name'];
            Session.lastName = userData[0]['last_name'];

            if (kDebugMode) {
              print(Session.userID);
            }
          });
        }
      }
      // ignore: empty_catches
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Session.firstName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Your Home Page!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'This is a simple home page built with Flutter.',
              style: TextStyle(fontSize: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserdataPage()));
                },
                child: const Text('Fetch User data'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Register()));
                },
                child: const Text('Add User data'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Addhotel()));
                },
                child: const Text('Add Hotels data'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HoteldataPage()));
                },
                child: const Text('Fetch Hotels data'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Addroom()));
                },
                child: const Text('Add Rooms data'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RoomdataPage()));
                },
                child: const Text('Fetch Rooms data'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookingDataPage()));
                },
                child: const Text('Add Booking data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
