import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.encode
import 'package:logger/logger.dart';

class Addroom extends StatefulWidget {
  const Addroom({Key? key}) : super(key: key);

  @override
  State<Addroom> createState() => _AddhotelState();
}

class _AddhotelState extends State<Addroom> {
  List<dynamic> _hotels = [];
  String? _selectedHotelId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hotelIdController = TextEditingController();
  // final TextEditingController _roomIdController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _number_of_roomsController =
      TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _amenitiesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _hotelIdController.dispose();
    //_roomIdController.dispose();
    _number_of_roomsController.dispose();
    _typeController.dispose();
    _amenitiesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchHotelData();
  }

  Future<void> _fetchHotelData() async {
    var url = Uri.parse('http://localhost:3000/api_fetch/allhoteldata');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          // Assuming the response is a list of hotel objects that contain a 'hotel_id' field
          _hotels = List<Map<String, dynamic>>.from(json.decode(response.body));
          if (_hotels.isNotEmpty) {
            _selectedHotelId = _hotels.first['hotel_id']
                .toString(); // Set the default selected hotel ID
          }
        });
      } else {
        debugPrint(
            'Failed to load hotel data with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching hotel data: $e');
    }
  }

  Future<void> submitRoomData() async {
    var logger = Logger();
    var url = Uri.parse(
        'http://localhost:3000/api_add/room'); // Adjust the URL as needed

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'hotelId': _selectedHotelId,
          //'room_id': _roomIdController.text,
          'number_of_rooms': _number_of_roomsController.text,
          'type': _typeController.text,
          'amenities': _amenitiesController.text,
          'price': _priceController.text,
        }),
      );

      if (response.statusCode == 200) {
        logger.d('Room data submitted successfully');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room added successfully')),
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {
        logger.w('Failed to submit Room data: ${response.body}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to add Room. Please try again.')),
        );
      }
    } catch (e) {
      logger.e('Error submitting hotel data: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Add Rooms';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/room.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedHotelId,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedHotelId = newValue;
                            });
                          },
                          items: _hotels.map<DropdownMenuItem<String>>((hotel) {
                            return DropdownMenuItem<String>(
                              value: hotel['hotel_id'].toString(),
                              child: Text(hotel['hotel_id'].toString()),
                            );
                          }).toList(),
                          decoration:
                              const InputDecoration(labelText: 'Select Hotel'),
                        ),
                        TextFormField(
                          controller: _number_of_roomsController,
                          decoration: const InputDecoration(
                              labelText: 'Number of room'),
                        ),
                        TextFormField(
                          controller: _typeController,
                          decoration:
                              const InputDecoration(labelText: 'Type'),
                        ),
                        TextFormField(
                          controller: _amenitiesController,
                          decoration:
                              const InputDecoration(labelText: 'amenities'),
                        ),
                        TextFormField(
                          controller: _priceController,
                          decoration:
                              const InputDecoration(labelText: 'price'),
                        ),
                        ElevatedButton(
                          onPressed: submitRoomData,
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
