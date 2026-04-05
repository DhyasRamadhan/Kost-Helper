class Room {
  final int id;
  final String roomNumber;
  final double price;
  final String status;

  Room({
    required this.id,
    required this.roomNumber,
    required this.price,
    required this.status,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      roomNumber: json['room_number'],
      price: json['price'].toDouble(),
      status: json['status'],
    );
  }
}