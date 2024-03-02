import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_hotel.dart';

class HoteldataPage extends StatefulWidget {
  const HoteldataPage({Key? key}) : super(key: key);

  @override
  State<HoteldataPage> createState() => _HoteldataPageState();
}

class _HoteldataPageState extends State<HoteldataPage> {
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

  Future<void> _deleteHotel(int hotelId) async {
    var url = Uri.parse(
        'http://localhost:3000/api_delete/deletehotel?hotel_id=$hotelId');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        debugPrint('Hotel deleted successfully');
        setState(() {
          _hotels.removeWhere((hotel) => hotel['hotel_id'] == hotelId);
        });
      } else {
        debugPrint(
            'Failed to delete hotel with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting hotel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Hotels Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://www.infoquest.co.th/wp-content/uploads/2022/11/20221109_canva_%E0%B9%82%E0%B8%A3%E0%B8%87%E0%B9%81%E0%B8%A3%E0%B8%A1-%E0%B8%97%E0%B8%B5%E0%B9%88%E0%B8%9E%E0%B8%B1%E0%B8%81-Hotel-1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _hotels.length,
          itemBuilder: (context, index) {
            var hotel = _hotels[index];
            return Card(
              color: Colors.white,
              elevation: 3,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                    '${hotel['hotel_id']} - ${hotel['name']} - ${hotel['city']}'),
                subtitle: Text('${hotel['description']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        double getRating(dynamic rating) {
                          if (rating is int) {
                            return rating.toDouble();
                          } else if (rating is double) {
                            return rating;
                          } else {
                            // Handle the case where rating is not a number.
                            // You may want to throw an error or return a default value.
                            return 0.0;
                          }
                        }

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HotelEditPage(
                              hotelId: hotel['hotel_id'],
                              name: hotel['name'],
                              description: hotel['description'],
                              address: hotel['address'],
                              city: hotel['city'],
                              state: hotel['state'],
                              country: hotel['country'],
                              zipCode: hotel['zip_code'],
                              rating: getRating(hotel['rating']),
                            ),
                          ),
                        );
                        _fetchHotelData(); // Refresh the entire list
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteHotel(hotel['hotel_id']),
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
