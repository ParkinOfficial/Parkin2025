import 'package:flutter/material.dart';
import 'package:parking/presentation/screens/menu/menu.dart';
import 'package:parking/presentation/widgets/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/presentation/screens/searchpark/search_park.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top 75% with map and settings icon
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                const UserLocationMap(markers: <Marker>{} ), // Your actual Google Map implementation

                Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuPage()));
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.settings, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom 25% vehicle options
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildVehicleIcon(context, Icons.pedal_bike, "Bicycle"),
                  _buildVehicleIcon(context, Icons.motorcycle, "Bike"),
                  _buildVehicleIcon(context, Icons.directions_car, "Car"),
                  _buildVehicleIcon(context, Icons.local_shipping, "Truck"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleIcon(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SearchParkingMapPage()));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}