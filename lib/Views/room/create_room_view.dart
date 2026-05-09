import 'package:flutter/material.dart';

class RoomFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Room")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: "Room Number")),

            TextField(decoration: InputDecoration(labelText: "Price")),

            DropdownButtonFormField(
              items: [
                DropdownMenuItem(child: Text("Available"), value: "available"),
                DropdownMenuItem(child: Text("Occupied"), value: "occupied"),
              ],
              onChanged: (v) {},
              decoration: InputDecoration(labelText: "Status"),
            ),

            SizedBox(height: 20),

            ElevatedButton(child: Text("Save"), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
