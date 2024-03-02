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
        title: const Text('Edit Hotel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),

      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://www.infoquest.co.th/wp-content/uploads/2022/11/20221109_canva_%E0%B9%82%E0%B8%A3%E0%B8%87%E0%B9%81%E0%B8%A3%E0%B8%A1-%E0%B8%97%E0%B8%B5%E0%B9%88%E0%B8%9E%E0%B8%B1%E0%B8%81-Hotel-1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), // Set white color with opacity
              borderRadius: BorderRadius.circular(16.0), // Add border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label text bold
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Add space between fields
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label text bold
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Add space between fields
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label text bold
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Add space between fields
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label text bold
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a City';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Add space between fields
                    TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label text bold
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a State';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Add space between fields
                    TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label text bold
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Country';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Add space between fields
                    TextFormField(
                      controller: _zipCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Zip Code',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label text bold
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Zip Code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16), // Add space between fields
                    TextFormField(
                      controller: _ratingController,
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold), // Make label text bold
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Rating';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24), // Add more space before button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _editUser(
                            widget.hotelId,
                            _nameController.text,
                            _descriptionController.text,
                            _addressController.text,
                            _cityController.text,
                            _stateController.text,
                            _countryController.text,
                            _zipCodeController.text,
                          ).then((_) {
                            Navigator.of(context).pop();
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error updating: $error')),
                            );
                          });
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
