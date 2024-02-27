import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.encode

class UserEditPage extends StatefulWidget {
  final int userId;
  final String email, firstName, lastName, phoneNumber;

  const UserEditPage({
    Key? key,
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController,
      _firstNameController,
      _lastNameController,
      _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
  }

  Future<void> _editUser(int userId, String email, String firstName,
      String lastName, String phoneNumber) async {
    if (kDebugMode) {
      print('Updating user with ID: $userId');
    }
    var url = Uri.parse('http://localhost:3000/api_update/update/$userId');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
        }),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('User updated successfully.');
        }
        // Optionally, refresh the UI or user list here if needed
      } else {
        if (kDebugMode) {
          print(
              'Failed to update user data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a first name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a last name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate form first
                if (_formKey.currentState!.validate()) {
                  _editUser(
                          widget.userId,
                          _emailController.text,
                          _firstNameController.text,
                          _lastNameController.text,
                          _phoneNumberController.text)
                      .then((_) {
                    // Handle success or error here, if necessary
                    Navigator.of(context)
                        .pop(); // Assuming you want to pop on success
                  }).catchError((error) {
                    // Handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating user: $error')),
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
