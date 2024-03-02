import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewForm extends StatefulWidget {
  const ReviewForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _reviewIdController = TextEditingController();
  final _hotelIdController = TextEditingController();
  final _userIdController = TextEditingController();
  final _ratingController = TextEditingController();
  final _commentController = TextEditingController();

  Future<void> submitReview() async {
    final int? reviewId = int.tryParse(_reviewIdController.text);
    final int? hotelId = int.tryParse(_hotelIdController.text);
    final int? userId = int.tryParse(_userIdController.text);
    final double? rating = double.tryParse(_ratingController.text);
    final String comment = _commentController.text;

    if (reviewId != null &&
        hotelId != null &&
        userId != null &&
        rating != null &&
        comment.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api_add/addReview'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'review_id': reviewId,
          'hotel_id': hotelId,
          'user_id': userId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        // Handle the response from the server
        if (kDebugMode) {
          print('Review added successfully');
        }
      } else {
        if (kDebugMode) {
          print('Failed to add review');
        }
      }
    } else {
      if (kDebugMode) {
        print('Please provide all required fields.');
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    _reviewIdController.dispose();
    _hotelIdController.dispose();
    _userIdController.dispose();
    _ratingController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _reviewIdController,
                decoration: const InputDecoration(labelText: 'Review ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Review ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hotelIdController,
                decoration: const InputDecoration(labelText: 'HotelID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Hotel ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'UserID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter User ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Rating';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Comment'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Comment ';
                  }
                  return null;
                },
              ),
              // ... Repeat for other fields using their respective controllers
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // Send the data to the server.
                    submitReview();
                  }
                },
                child: const Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
