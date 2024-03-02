import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_booking/Report/report_booking.dart';
import 'package:flutter_app_booking/Report/report_hotel.dart';
import 'package:flutter_app_booking/Report/report_review.dart';
import 'package:flutter_app_booking/Report/report_room.dart';
import 'package:flutter_app_booking/Report/report_user.dart';
import 'package:flutter_app_booking/add_booking.dart';
import 'package:flutter_app_booking/add_hotel.dart';
import 'package:flutter_app_booking/add_review.dart';
import 'package:flutter_app_booking/add_room.dart';
import 'package:flutter_app_booking/edit_user.dart';
import 'package:flutter_app_booking/login.dart';
import 'package:flutter_app_booking/register.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:flutter_app_booking/show_all_booking_data.dart';
import 'package:flutter_app_booking/show_all_reviews.data.dart';
import 'package:flutter_app_booking/show_all_room_data.dart';

import 'package:flutter_app_booking/show_all_user_data.dart';

import 'show_all_hotel_data.dart';

void main() => runApp(const AdminApp());

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch:
            createMaterialColor(const Color.fromARGB(255, 84, 87, 88)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AdminDashboardPage(),
    );
  }
}

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => handleMenuClick(context, value),
            itemBuilder: (BuildContext context) {
              return {'Profile', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            AdminCard(
              title: 'User Management',
              icon1: Icons.person_add,
              text1: 'Add User',
              icon2: Icons.edit,
              text2: 'Edit User',
              icon3: Icons.my_library_books,
              text3: 'Report User',
              onPressed1: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Register()));
              },
              onPressed2: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserdataPage()));
              },
              onPressed3: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportUserdataPage()));
              },
            ),

            AdminCard(
              title: 'Hotels Management',
              icon1: Icons.hotel,
              text1: 'Add Hotels',
              icon2: Icons.edit,
              text2: 'Edit Hotels',
              icon3: Icons.my_library_books,
              text3: 'Hotels Report',
              onPressed1: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Addhotel()));
              },
              onPressed2: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HoteldataPage()));
              },
              onPressed3: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportHoteldataPage()));
              },
            ),

            AdminCard(
              title: 'Rooms Management',
              icon1: Icons.meeting_room,
              text1: 'Add Rooms',
              icon2: Icons.edit,
              text2: 'Edit Rooms',
              icon3: Icons.my_library_books,
              text3: 'Rooms Report',
              onPressed1: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Addroom()));
              },
              onPressed2: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RoomdataPage()));
              },
              onPressed3: () {
                // Navigate to Booking Report Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportRoomdataPage()));
              },
            ),

            AdminCard(
              title: 'Review Management',
              icon1: Icons.rate_review,
              text1: 'Add Review',
              icon2: Icons.edit,
              text2: 'Edit Review',
              icon3: Icons.my_library_books,
              text3: 'Review Report',
              onPressed1: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReviewForm()));
              },
              onPressed2: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReviewdataPage()));
              },
              onPressed3: () {
                // Navigate to Review Report Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportReviewdataPage()));
              },
            ),

            AdminCard(
              title: 'Booking Management',
              icon1: Icons.menu_book,
              text1: 'Add Booking',
              icon2: Icons.edit,
              text2: 'Edit Booking',
              icon3: Icons.my_library_books,
              text3: 'Booking Report',
              onPressed1: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingDataPage()));
              },
              onPressed2: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingdataPageShow()));
              },
              onPressed3: () {
                // Navigate to About Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportBookingDataPage()));
              },
            ),
            // ... Add more AdminCard widgets for each category
          ],
        ),
      ),
    );
  }

  void handleMenuClick(BuildContext context, String value) {
    // ignore: non_constant_identifier_names
    switch (value) {
      case 'Profile':
        if (kDebugMode) {
          print('Test User ID form Admin');
          print(Session.userID);
        }
        if (Session.userID != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserEditPage(
                userId: Session.userID ??
                    -1, // Use -1 or another value as the default,
                email: Session.email,
                firstName: Session.firstName,
                lastName: Session.lastName,
                phoneNumber: Session.phonenumber,
              ),
            ),
          );
        } else {}

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

class AdminCard extends StatelessWidget {
  final String title;
  final IconData icon1, icon2, icon3;
  final String text1, text2, text3;
  final VoidCallback onPressed1, onPressed2, onPressed3;

  const AdminCard({
    Key? key,
    required this.title,
    required this.icon1,
    required this.icon2,
    required this.icon3,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.onPressed1,
    required this.onPressed2,
    required this.onPressed3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: 20.0, thickness: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AdminButton(
                    icon: icon1,
                    text: text1,
                    onPressed: onPressed1,
                    backgroundColor: const Color.fromARGB(255, 123, 228, 145),
                  ),
                ),
                Expanded(
                  child: AdminButton(
                    icon: icon2,
                    text: text2,
                    onPressed: onPressed2,
                    backgroundColor: const Color.fromARGB(255, 255, 194, 81),
                  ),
                ),
                Expanded(
                  child: AdminButton(
                    icon: icon3,
                    text: text3,
                    onPressed: onPressed3,
                    backgroundColor: const Color.fromARGB(255, 77, 154, 255),
                  ),
                ),
              ],
            ),
            // Additional Rows can be added here if needed
          ],
        ),
      ),
    );
  }
}

class AdminButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  const AdminButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
