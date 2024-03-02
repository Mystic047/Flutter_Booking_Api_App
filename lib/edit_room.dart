// ignore: unused_import
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.encode

class RoomEditPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int hotelId, roomId, number_of_rooms;
  final String type, amenities;
  final double price;

  const RoomEditPage({
    Key? key,
    required this.hotelId,
    // ignore: non_constant_identifier_names
    required this.number_of_rooms,
    required this.roomId,
    required this.type,
    required this.price,
    required this.amenities,
  }) : super(key: key);

  @override
  State<RoomEditPage> createState() => _RoomEditPageState();
}

class _RoomEditPageState extends State<RoomEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _hotelIdController,
      _roomIdController,
      // ignore: non_constant_identifier_names
      _number_of_roomsController,
      _typeController,
      _amenitiesController,
      _priceController;

  @override
  void initState() {
    super.initState();
    _hotelIdController = TextEditingController(text: widget.hotelId.toString());
    _roomIdController = TextEditingController(text: widget.roomId.toString());
    _typeController = TextEditingController(text: widget.type);
    _number_of_roomsController =
        TextEditingController(text: widget.number_of_rooms.toString());
    _amenitiesController = TextEditingController(text: widget.amenities);
    _priceController = TextEditingController(text: widget.price.toString());
  }

  Future<void> _editRoom(int hotelId, roomId, numberOfRooms, String type,
      String amenities, double price) async {
    if (kDebugMode) {
      print('Updating room with ID: $roomId');
    }
    var url = Uri.parse('http://localhost:3000/api_update/updateRoom/$roomId');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'hotelId': hotelId,
          'roomId': roomId,
          'number_of_rooms': numberOfRooms,
          'type': type,
          'amenities': amenities,
          'price': price,
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
              'Failed to update Room data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating Room data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Room'),
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
              controller: _hotelIdController,
              decoration: const InputDecoration(labelText: 'Hotel id'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an Hotel id';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _roomIdController,
              decoration: const InputDecoration(labelText: 'Room id'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Room id';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Type';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _number_of_roomsController,
              decoration: const InputDecoration(labelText: 'number of room'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number of room';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _amenitiesController,
              decoration: const InputDecoration(labelText: 'Amenities'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Amenities';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Price';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate form first
                if (_formKey.currentState!.validate()) {
                  try {
                    int hotelId = int.parse(_hotelIdController.text);
                    int roomId = int.parse(_roomIdController.text);
                    int numberOfRooms =
                        int.parse(_number_of_roomsController.text);
                    double price = double.parse(_priceController.text);

                    _editRoom(
                      hotelId,
                      roomId,
                      numberOfRooms,
                      _typeController.text,
                      _amenitiesController.text,
                      price,
                    ).then((_) {
                      // Handle success or error here, if necessary
                      Navigator.of(context)
                          .pop(); // Assuming you want to pop on success
                    }).catchError((error) {
                      // Handle error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating room: $error')),
                      );
                    });
                  } catch (e) {
                    // Handle parsing error, e.g., show a Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid input: $e')),
                    );
                  }
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
