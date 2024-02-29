import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_booking/edit_review.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.decode
import 'session.dart';

class ReviewdataPage extends StatefulWidget {
  const ReviewdataPage({Key? key}) : super(key: key);

  @override
  State<ReviewdataPage> createState() => _ReviewdataPageState();
}

class _ReviewdataPageState extends State<ReviewdataPage> {
  List<dynamic> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviewData();
  }

  Future<void> _fetchReviewData() async {
    var url = Uri.parse('http://localhost:3000/api_fetch/allreviewdata');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _reviews = json.decode(response.body);
        });
      } else {
        if (kDebugMode) {
          print(
              'Failed to load user data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching review data: $e');
      }
    }
  }

  Future<void> _deleteUser(int reviewId) async {
    if (kDebugMode) {
      print('Deleting reviews with ID: $reviewId');
    }
    var url = Uri.parse(
        'http://localhost:3000/api_delete/deletereview?review_id=$reviewId');

    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('review deleted successfully');
        }
        setState(() {
          _reviews.removeWhere((review) => review['review_id'] == reviewId);
        });
      } else {
        if (kDebugMode) {
          print(
              'Failed to delete review data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting review data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Session.firstName),
      ),
      body: ListView.builder(
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          var review = _reviews[index];
          return ListTile(
            title: Text(
                'review ID :${review['review_id']} Hotel ID : ${review['hotel_id']} User ID :${review['user_id']} '),
            subtitle: Text(
                'rating : ${review['rating']} comment : ${review['comment']} '),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // When opening UserEditPage from UserdataPage or wherever you have the list
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReviewEditPage(
                          reviewId: review['review_id'],
                          hotelId: review['hotel_id'],
                          userId: review['user_id'],
                          rating: review['rating'] != null
                              ? review['rating'].toDouble()
                              : 0.0,
                          comment: review['comment'],
                        ),
                      ),
                    );
                    _fetchReviewData(); // Refresh the entire list
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(review['review_id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
