import 'package:flutter/material.dart';
import 'package:flutter_app_booking/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.decode

class ReportRoomdataPage extends StatefulWidget {
  const ReportRoomdataPage({Key? key}) : super(key: key);

  @override
  State<ReportRoomdataPage> createState() => _ReportRoomdataPageState();
}

class _ReportRoomdataPageState extends State<ReportRoomdataPage> {
  List<dynamic> _rooms = [];

  @override
  void initState() {
    super.initState();
    _fetchRoomData();
  }

  Future<void> _fetchRoomData() async {
    var url = Uri.parse('http://localhost:3000/api_fetch/allroomdata');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _rooms = json.decode(response.body);
        });
      } else {
        debugPrint(
            'Failed to load hotel data with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching room data: $e');
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
          itemCount: _rooms.length,
          itemBuilder: (context, index) {
            var room = _rooms[index];
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
                        'Room Id : ${room['room_id']} Type : ${room['type']}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.bed_rounded,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(
                                  ' Number of room : ${room['number_of_rooms'].toString()}')),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.apartment,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child: Text(' Amenities : ${room['amenities']}')),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.money,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 8.0),
                          Expanded(
                              child:
                                  Text(' Price : ${room['price'].toString()}')),
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
