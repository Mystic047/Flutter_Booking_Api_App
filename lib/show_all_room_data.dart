import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_room.dart';
// ignore: unused_import
import 'edit_hotel.dart';

class RoomdataPage extends StatefulWidget {
  const RoomdataPage({Key? key}) : super(key: key);

  @override
  State<RoomdataPage> createState() => _RoomdataPageState();
}

class _RoomdataPageState extends State<RoomdataPage> {
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

  Future<void> _deleteRoom(int roomId) async {
    var url = Uri.parse(
        'http://localhost:3000/api_delete/deleteroom?room_id=$roomId');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        debugPrint('Hotel deleted successfully');
        setState(() {
          _rooms.removeWhere((hotel) => hotel['room_id'] == roomId);
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
        title: const Text('All Rooms Data'),
      ),
      body: ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          var room = _rooms[index];
          return ListTile(
            title:
                Text('${room['room_id']} - ${room['type']} - ${room['price']}'),
            subtitle: Text('${room['number_of_rooms']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () async {
                    double getPrice(
                      dynamic price,
                    ) {
                      if (price is int) {
                        return price.toDouble();
                      } else if (price is double) {
                        return price;
                      } else {
                        // Handle the case where rating is not a number.
                        // You may want to throw an error or return a default value.
                        return 0.0;
                      }
                    }

                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoomEditPage(
                          roomId: room['room_id'],
                          hotelId: room['hotel_id'],
                          type: room['type'],
                          price: getPrice(room['price']),
                          number_of_rooms: room[
                              'number_of_rooms'], // Correctly pass the parameter here
                          amenities: room[
                              'amenities'], // Correctly pass the parameter here
                        ),
                      ),
                    );
                    _fetchRoomData(); // Refresh the entire list
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteRoom(room['room_id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
