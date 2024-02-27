import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.encode
import 'package:logger/logger.dart';

class Addhotel extends StatefulWidget {
  const Addhotel({Key? key}) : super(key: key);

  @override
  State<Addhotel> createState() => _AddhotelState();
}

class _AddhotelState extends State<Addhotel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  late TextEditingController _ratingController;
  @override
  void initState() {
    super.initState();
    double initialValue =
        0.0; // Define the initialValue here or pass it from the widget if needed.
    _ratingController =
        TextEditingController(text: initialValue.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _zipCodeController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> submitHotelData() async {
    var logger = Logger();
    var url = Uri.parse(
        'http://localhost:3000/api_add/hotel'); // Adjust the URL as needed

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'country': _countryController.text,
          'zip_code': _zipCodeController.text,
          'rating':
              _ratingController.text, // Ensure rating is acceptable format
        }),
      );

      if (response.statusCode == 200) {
        logger.d('Hotel data submitted successfully');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel added successfully')),
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {
        logger.w('Failed to submit hotel data: ${response.body}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to add hotel. Please try again.')),
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
    const String appTitle = 'Add Hotel';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Hotel Name'),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Hotel Description'),
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration:
                        const InputDecoration(labelText: 'Hotel Adress'),
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'Hotel city'),
                  ),
                  TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(labelText: 'Hotel state'),
                  ),
                  TextFormField(
                    controller: _countryController,
                    decoration:
                        const InputDecoration(labelText: 'Hotel country'),
                  ),
                  TextFormField(
                    controller: _zipCodeController,
                    decoration:
                        const InputDecoration(labelText: 'Hotel zipCode'),
                  ),

                  // Add other fields similarly...
                  ElevatedButton(
                    onPressed: submitHotelData,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
