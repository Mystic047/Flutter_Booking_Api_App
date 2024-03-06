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
    _number_of_roomsController = TextEditingController(text: widget.number_of_rooms.toString());
    _amenitiesController = TextEditingController(text: widget.amenities);
    _priceController = TextEditingController(text: widget.price.toString());
  }

  Future<void> _editRoom(int hotelId, roomId, numberOfRooms, String type, String amenities, double price) async {
    if (kDebugMode) {
      print('Updating room with ID: $roomId');
    }
    var url = Uri.parse('http://localhost:3000/api_update/updateRoom/$roomId');

    try {
      var response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
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
          print('Room updated successfully.');
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(); // Optionally pop the context
      } else {
        if (kDebugMode) {
          print('Failed to update Room data with status code: ${response.statusCode}');
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/22/25/ce/ea/kingsford-hotel-manila.jpg?w=1200&h=-1&s=1'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _hotelIdController,
                      decoration: const InputDecoration(labelText: 'Hotel ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Hotel ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _roomIdController,
                      decoration: const InputDecoration(labelText: 'Room ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Room ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(labelText: 'Type'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a type';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _number_of_roomsController,
                      decoration: const InputDecoration(labelText: 'Number of Rooms'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of rooms';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _amenitiesController,
                      decoration: const InputDecoration(labelText: 'Amenities'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amenities';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Only proceed if the form is valid
                          _editRoom(
                            int.parse(_hotelIdController.text),
                            int.parse(_roomIdController.text),
                            int.parse(_number_of_roomsController.text),
                            _typeController.text,
                            _amenitiesController.text,
                            double.parse(_priceController.text),
                          );
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
