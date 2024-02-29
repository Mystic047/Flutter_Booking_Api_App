import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.encode

class ReviewEditPage extends StatefulWidget {
  final int reviewId, hotelId, userId;
  final double rating;
  final String comment;

  const ReviewEditPage({
    Key? key,
    required this.userId,
    required this.hotelId,
    required this.reviewId,
    required this.rating,
    required this.comment,
  }) : super(key: key);

  @override
  State<ReviewEditPage> createState() => _ReviewEditPageState();
}

class _ReviewEditPageState extends State<ReviewEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userIdController,
      _hotelIdController,
      _reviewIdController,
      _commentController,
      _ratingController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: widget.userId.toString());
    _hotelIdController = TextEditingController(text: widget.hotelId.toString());
    _reviewIdController =
        TextEditingController(text: widget.reviewId.toString());
    _ratingController = TextEditingController(text: widget.rating.toString());
    _commentController = TextEditingController(text: widget.comment);
  }

  Future<void> _editReview(
      int userId, hotelId, reviewId, String comment, double rating) async {
    if (kDebugMode) {
      print('Updating Reviews with ID: $reviewId');
    }
    var url =
        Uri.parse('http://localhost:3000/api_update/updateReview/$reviewId');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'review_id': reviewId,
          'hotel_id': hotelId,
          'user_id': userId,
          'comment': comment,
          'rating': rating,
        }),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Reviews updated successfully.');
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
        title: const Text('Edit Review'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an User ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _hotelIdController,
              decoration: const InputDecoration(labelText: 'Hotel ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Hotel ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _reviewIdController,
              decoration: const InputDecoration(labelText: 'Reviews ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Reviews ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Comment';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Rating'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Rating';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                double? rating = double.tryParse(_ratingController.text);

                if (rating == null) {
                  // Handle the case where the string did not contain a valid double
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid rating.')),
                  );
                  return; // Exit the function if parsing failed
                }
                // Validate form first
                if (_formKey.currentState!.validate()) {
                  _editReview(
                    widget.userId,
                    int.tryParse(_hotelIdController.text) ??
                        0, // Replace 0 with an appropriate default or error value
                    int.tryParse(_reviewIdController.text) ??
                        0, // Replace 0 with an appropriate default or error value
                    _commentController.text,
                    rating,
                  ).then((_) {
                    // Handle success
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    // Handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating review: $error')),
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
