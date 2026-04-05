import 'package:flutter/material.dart';
import 'room_form_page.dart';

class RoomListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rooms")),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RoomFormPage()),
          );
        },
      ),

      body: ListView.builder(
        itemCount: 5,

        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Room ${index + 1}"),
            subtitle: Text("Status: Occupied"),

            trailing: Icon(Icons.edit),
          );
        },
      ),
    );
  }
}
