import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiScreen extends StatefulWidget {
  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List<dynamic> users = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error: Unable to fetch users.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> addUser(String name, String email) async {
    final newUser = {
      "name": name,
      "email": email,
      "phone": "123-456-7890",
      "website": "example.com",
      "address": {"street": "123 Main St", "city": "Anytown"}
    };

    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
        body: json.encode(newUser),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        setState(() {
          users.add(json.decode(response.body));
        });
      } else {
        _showErrorDialog('Failed to add user. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  Future<void> editUser(int id, String name, String email) async {
    final editedUser = {
      "id": id,
      "name": name,
      "email": email,
      "phone": "123-456-7890",
      "website": "example.com",
      "address": {"street": "123 Main St", "city": "Anytown"}
    };

    try {
      final response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
        body: json.encode(editedUser),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          users = users.map((user) {
            return user['id'] == id ? editedUser : user;
          }).toList();
        });
      } else {
        _showErrorDialog('Failed to edit user. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
          Uri.parse('https://jsonplaceholder.typicode.com/users/$id'));

      if (response.statusCode == 200) {
        setState(() {
          users.removeWhere((user) => user['id'] == id);
        });
      } else {
        _showErrorDialog('Failed to delete user. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    String name = '';
    String email = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                email = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addUser(name, email);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(int id, String currentName, String currentEmail) {
    String name = currentName;
    String email = currentEmail;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: currentName),
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: currentEmail),
              onChanged: (value) {
                email = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              editUser(id, name, email);
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteUser(id);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddUserDialog,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user['name'][0]),
              ),
              title: Text(user['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['email']),
                  Text(user['phone']),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditUserDialog(
                        user['id'], user['name'], user['email']);
                  } else if (value == 'delete') {
                    _showDeleteUserDialog(user['id']);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
