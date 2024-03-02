// ignore_for_file: use_build_context_synchronously, duplicate_ignore

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
    double initialValue = 0.0;
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
    var url = Uri.parse('http://localhost:3000/api_add/hotel');

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
          'rating': _ratingController.text,
        }),
      );

      if (response.statusCode == 200) {
        logger.d('Hotel data submitted successfully');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel added successfully')),
        );
        Navigator.of(context).pop();
      } else {
        logger.w('Failed to submit hotel data: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to add hotel. Please try again.')),
        );
      }
    } catch (e) {
      logger.e('Error submitting hotel data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Add Hotel';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                  // Background Image
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://www.infoquest.co.th/wp-content/uploads/2022/11/20221109_canva_%E0%B9%82%E0%B8%A3%E0%B8%87%E0%B9%81%E0%B8%A3%E0%B8%A1-%E0%B8%97%E0%B8%B5%E0%B9%88%E0%B8%9E%E0%B8%B1%E0%B8%81-Hotel-1.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Form Fields
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
