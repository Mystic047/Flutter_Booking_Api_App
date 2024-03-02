import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewSubmissionPage extends StatefulWidget {
  final int roomId;
  const ReviewSubmissionPage({Key? key, required this.roomId})
      : super(key: key);

  @override
  _ReviewSubmissionPageState createState() => _ReviewSubmissionPageState();
}

class _ReviewSubmissionPageState extends State<ReviewSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  late int _hotelId;
  final int _reviewId = 0;
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchHotelIdFromRoom();
  }

  @override
  void dispose() {
    _ratingController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchHotelIdFromRoom() async {
    var url = Uri.parse(
        'http://localhost:3000/api_fetch/hotel_id_from_room/${widget.roomId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _hotelId = data['hotel_id'];
        });
      } else {
        throw Exception('Failed to load hotel id');
      }
    } catch (e) {
      debugPrint('Error fetching hotel ID: $e');
      setState(() {
        _hotelId = -1; // Indicating an error
      });
    }
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final double? rating = double.tryParse(_ratingController.text);
      final String comment = _commentController.text;

      if (rating != null && comment.isNotEmpty) {
        final url = Uri.parse('http://localhost:3000/api_add/addReview');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'review_id': _reviewId,
            'hotel_id': _hotelId,
            'user_id': Session.userID,
            'rating': rating,
            'comment': comment,
          }),
        );

        if (response.statusCode == 200) {
          debugPrint('Review added successfully');
          Navigator.pop(context);
        } else {
          debugPrint('Failed to add review');
        }
      } else {
        debugPrint('Please provide all required fields.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating (1-5)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
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
                    return 'Please enter a comment';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitReview,
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
