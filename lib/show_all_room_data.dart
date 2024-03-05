import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_room.dart';

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
        debugPrint('Failed to load room data with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching room data: $e');
    }
  }

  Future<void> _deleteRoom(int roomId) async {
    var url = Uri.parse('http://localhost:3000/api_delete/deleteroom?room_id=$roomId');
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        debugPrint('Room deleted successfully');
        setState(() {
          _rooms.removeWhere((room) => room['room_id'] == roomId);
        });
      } else {
        debugPrint('Failed to delete room with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting room: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Rooms Data'),
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
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: ListTile(
                title: Text('${room['room_id']} - ${room['type']} - ${room['price']}'),
                subtitle: Text('${room['number_of_rooms']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RoomEditPage(
                              roomId: room['room_id'],
                              hotelId: room['hotel_id'],
                              type: room['type'],
                              price: room['price'] is int ? room['price'].toDouble() : room['price'],
                              number_of_rooms: room['number_of_rooms'],
                              amenities: room['amenities'],
                            ),
                          ),
                        );
                        _fetchRoomData(); // Refresh the list after editing
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRoom(room['room_id']),
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
