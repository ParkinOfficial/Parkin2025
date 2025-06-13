import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile info
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/profile.jpg"), // or NetworkImage
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("John Doe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("johndoe@example.com", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Menu List
          _buildMenuItem(context, Icons.calendar_today, "My Bookings", () {
            // Navigate to bookings
          }),
          _buildMenuItem(context, Icons.person, "Profile Details", () {
            // Navigate to profile details
          }),
          _buildMenuItem(context, Icons.payment, "Payment Methods", () {
            // Navigate to payment
          }),
          _buildMenuItem(context, Icons.directions_car, "My Vehicles", () {
            // Navigate to vehicle management
          }),
          _buildMenuItem(context, Icons.help_outline, "Help & Support", () {
            // Navigate to support
          }),
          _buildMenuItem(context, Icons.logout, "Logout", () {
            // Add logout logic
            Navigator.popUntil(context, (route) => route.isFirst);
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
    );
  }
}
