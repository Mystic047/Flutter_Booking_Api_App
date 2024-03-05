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
          print('Failed to load review data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching review data: $e');
      }
    }
  }

  Future<void> _deleteReview(int reviewId) async {
    if (kDebugMode) {
      print('Deleting review with ID: $reviewId');
    }
    var url = Uri.parse('http://localhost:3000/api_delete/deletereview?review_id=$reviewId');

    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Review deleted successfully');
        }
        setState(() {
          _reviews.removeWhere((review) => review['review_id'] == reviewId);
        });
      } else {
        if (kDebugMode) {
          print('Failed to delete review with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting review: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Session.firstName),
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
        child: ListView.builder(
          itemCount: _reviews.length,
          itemBuilder: (context, index) {
            var review = _reviews[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: ListTile(
                title: Text(
                    'Review ID: ${review['review_id']} Hotel ID: ${review['hotel_id']} User ID: ${review['user_id']}'),
                subtitle: Text(
                    'Rating: ${review['rating']} Comment: ${review['comment']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReviewEditPage(
                              reviewId: review['review_id'],
                              hotelId: review['hotel_id'],
                              userId: review['user_id'],
                              rating: review['rating'] != null ? review['rating'].toDouble() : 0.0,
                              comment: review['comment'],
                            ),
                          ),
                        );
                        _fetchReviewData(); // Refresh the list after editing
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteReview(review['review_id']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
