import 'package:flutter/material.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.decode

class ReportHoteldataPage extends StatefulWidget {
  const ReportHoteldataPage({Key? key}) : super(key: key);

  @override
  State<ReportHoteldataPage> createState() => _ReportHoteldataPageState();
}

class _ReportHoteldataPageState extends State<ReportHoteldataPage> {
  List<dynamic> _hotels = [];

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
          _hotels = json.decode(response.body);
        });
      } else {
        debugPrint(
            'Failed to load hotel data with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching hotel data: $e');
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
          itemCount: _hotels.length,
          itemBuilder: (context, index) {
            var hotel = _hotels[index];
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
                        'Hotel Id :${hotel['hotel_id']}  Hotel Name :${hotel['name']}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.location_city,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(
                                  'Country :${hotel['country']} City : ${hotel['city']} State :${hotel['state']} ')),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.phone,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(
                                  hotel['description'] ?? 'No description')),
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
