import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FoodCard extends StatelessWidget {
  final List<String> imageUrls;
  final String title;
  final double rating;
  final String deliveryTime;
  final String distance;
  final String price;
  final String offer;
  final String tag;

  const FoodCard({
    Key? key,
    required this.imageUrls,
    required this.title,
    required this.rating,
    required this.deliveryTime,
    required this.distance,
    required this.price,
    required this.offer,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel
          Stack(
            children: [
              CarouselSlider(
                items: imageUrls.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      url,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 180,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                ),
              ),
              // Top Left Tag
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          // Details Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery & Distance
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(deliveryTime, style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 12),
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(distance, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 6),
                // Title
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 6),
                // Rating and Price
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            rating.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.star, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('₹$price', style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(height: 6),
                // Offer
                if (offer.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.local_offer, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(offer, style: TextStyle(color: Colors.blue)),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
