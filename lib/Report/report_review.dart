import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.decode

class ReportReviewdataPage extends StatefulWidget {
  const ReportReviewdataPage({Key? key}) : super(key: key);

  @override
  State<ReportReviewdataPage> createState() => _ReportReviewdataPageState();
}

class _ReportReviewdataPageState extends State<ReportReviewdataPage> {
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
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
                  // Handle tap if necessary, for example, to view detailed user profile
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review Id : ${review['review_id'].toString()} ',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.hotel,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(
                                  ' Hotel Id: ${review['hotel_id'].toString()} User Id : ${review['user_id'].toString()}')),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.comment,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(' Comment : ${review['comment']}')),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.rate_review,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(
                                  ' Rating : ${review['rating'].toString()}')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
