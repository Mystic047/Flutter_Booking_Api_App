// ignore: unused_import
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.encode

class HotelEditPage extends StatefulWidget {
  final int hotelId;
  final String name, description, address, city, state, country, zipCode;
  final double rating;

  const HotelEditPage({
    Key? key,
    required this.hotelId,
    required this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.rating,
    required this.name,
  }) : super(key: key);

  @override
  State<HotelEditPage> createState() => _HotelEditPageState();
}

class _HotelEditPageState extends State<HotelEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController,
      _descriptionController,
      _addressController,
      _cityController,
      _stateController,
      _countryController,
      _zipCodeController,
      _ratingController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _addressController = TextEditingController(text: widget.address);
    _cityController = TextEditingController(text: widget.city);
    _stateController = TextEditingController(text: widget.state);
    _countryController = TextEditingController(text: widget.country);
    _zipCodeController = TextEditingController(text: widget.zipCode);
    _ratingController = TextEditingController(text: widget.rating.toString());
  }

  Future<void> _editUser(
      int hotelId,
      String name,
      String description,
      String address,
      String city,
      String state,
      String country,
      String zipCode) async {
    if (kDebugMode) {
      print('Updating user with ID: $hotelId');
    }
    var url =
        Uri.parse('http://localhost:3000/api_update/updateHotel/$hotelId');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'description': description,
          'address': address,
          'city': city,
          'state': state,
          'country': country,
          'zip_code': zipCode,
        }),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Hotel updated successfully.');
        }
        // Optionally, refresh the UI or user list here if needed
      } else {
        if (kDebugMode) {
          print(
              'Failed to update Hotel data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating Hotel data: $e');
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
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an Name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Adress'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Adress';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a City';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'state'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a state';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'country'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a country';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _zipCodeController,
              decoration: const InputDecoration(labelText: 'zipCode'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a zipCode';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'rating'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a rating';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate form first
                if (_formKey.currentState!.validate()) {
                  _editUser(
                          widget.hotelId,
                          _nameController.text,
                          _descriptionController.text,
                          _addressController.text,
                          _cityController.text,
                          _stateController.text,
                          _countryController.text,
                          _zipCodeController.text)
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
