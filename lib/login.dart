import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_booking/ForUser/user_booking_page.dart';

// ignore: unused_import

import 'package:flutter_app_booking/admin_dashboard.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: unused_import
import 'home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();

  // Login Function
  Future<void> auth() async {
    var logger = Logger();
    var url = Uri.parse('http://localhost:3000/api_auth/login');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        logger.d('Login successfully');
        fetchUserData(
            _emailController.text); // Optionally use the response data
        if (kDebugMode) {
          print('Logged in with email: ${responseData['email']}');
        }

        // Proceed to HomePage without using a token
        if (mounted) {
          if (_emailController.text == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminApp(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserBookingDataPage(),
              ),
            );
          }
        }
      } else {
        logger.w('Failed to Login: ${response.body}');
      }
    } catch (e) {
      logger.e('Error Login: $e');
    }
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
            Session.userID = userData[0]['user_id'];
            Session.email = userData[0]['email'] ?? '';
            Session.firstName = userData[0]['first_name'] ?? '';
            Session.lastName = userData[0]['last_name'] ?? '';
            Session.phonenumber = userData[0]['phone_number'] ??
                ''; // Ensure the key matches what's returned from the API

            if (kDebugMode) {
              print('User ID: ${Session.userID}');
            }
          });
        } else {
          if (kDebugMode) {
            print('No user found with that email.');
          }
        }
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch user data with status code: ${response.statusCode}');
        }
      }
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
        title: const Text('Login'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/22/25/ce/ea/kingsford-hotel-manila.jpg?w=1200&h=-1&s=1'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://logodownload.org/wp-content/uploads/2017/02/manchester-city-fc-logo-escudo-badge.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add more sophisticated email validation if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add more sophisticated password validation if needed
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          auth();
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
