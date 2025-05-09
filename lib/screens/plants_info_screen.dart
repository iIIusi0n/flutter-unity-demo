import 'package:flutter/material.dart';

class Plant {
  final String name;
  final DateTime plantedDate;
  final int wateringFrequency; // in days
  final double growthProgress; // 0.0 to 1.0

  Plant({
    required this.name,
    required this.plantedDate,
    required this.wateringFrequency,
    required this.growthProgress,
  });
}

class PlantsInfoScreen extends StatefulWidget {
  const PlantsInfoScreen({super.key});

  @override
  State<PlantsInfoScreen> createState() => _PlantsInfoScreenState();
}

class _PlantsInfoScreenState extends State<PlantsInfoScreen> {
  // Dummy data for demonstration
  final List<Plant> plants = [
    Plant(
      name: '토마토',
      plantedDate: DateTime.now().subtract(const Duration(days: 5)),
      wateringFrequency: 2,
      growthProgress: 0.4,
    ),
    Plant(
      name: '당근',
      plantedDate: DateTime.now().subtract(const Duration(days: 3)),
      wateringFrequency: 1,
      growthProgress: 0.2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 식물'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                plant.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('심은 날짜: ${plant.plantedDate.toString().split(' ')[0]}'),
                  Text('물주기: ${plant.wateringFrequency}일마다'),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: plant.growthProgress,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '성장률: ${(plant.growthProgress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 12),
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