import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using json.decode
import 'edit_user.dart';
import 'session.dart';

class UserdataPage extends StatefulWidget {
  const UserdataPage({Key? key}) : super(key: key);

  @override
  State<UserdataPage> createState() => _UserdataPageState();
}

class _UserdataPageState extends State<UserdataPage> {
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    var url = Uri.parse('http://localhost:3000/api_fetch/alluserdata');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body);
        });
      } else {
        if (kDebugMode) {
          print(
              'Failed to load user data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _deleteUser(int userId) async {
    if (kDebugMode) {
      print('Deleting user with ID: $userId');
    }
    var url = Uri.parse(
        'http://localhost:3000/api_delete/deleteuser?user_id=$userId');

    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('User deleted successfully');
        }
        setState(() {
          _users.removeWhere((user) => user['user_id'] == userId);
        });
      } else {
        if (kDebugMode) {
          print(
              'Failed to delete user data with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user data: $e');
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
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          var user = _users[index];
          return ListTile(
            title: Text('${user['first_name']} ${user['last_name']}'),
            subtitle: Text(user['email']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // When opening UserEditPage from UserdataPage or wherever you have the list
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserEditPage(
                          userId: user['user_id'],
                          email: user['email'],
                          firstName: user['first_name'],
                          lastName: user['last_name'],
                          phoneNumber: user['phone_number'],
                        ),
                      ),
                    );
                    _fetchUserData(); // Refresh the entire list
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(user['user_id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
