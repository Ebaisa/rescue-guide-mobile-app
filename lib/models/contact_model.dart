class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name']?.toString() ?? 'Unknown',
      phoneNumber: json['phoneNumber']?.toString() ?? 'No phone',
    );
  }
}
