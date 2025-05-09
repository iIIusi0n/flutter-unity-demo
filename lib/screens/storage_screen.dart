import 'package:flutter/material.dart';

class HarvestedPlant {
  final String name;
  final int quantity;
  final DateTime harvestDate;

  HarvestedPlant({
    required this.name,
    required this.quantity,
    required this.harvestDate,
  });
}

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  // Dummy data for demonstration
  final List<HarvestedPlant> harvestedPlants = [
    HarvestedPlant(
      name: '토마토',
      quantity: 5,
      harvestDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    HarvestedPlant(
      name: '당근',
      quantity: 3,
      harvestDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final Set<int> selectedPlants = {};

  void _toggleSelection(int index) {
    setState(() {
      if (selectedPlants.contains(index)) {
        selectedPlants.remove(index);
      } else {
        selectedPlants.add(index);
      }
    });
  }

  void _deliverSelectedPlants() {
    if (selectedPlants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('배송할 식물을 선택해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement delivery logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('식물이 성공적으로 배송되었습니다!'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      selectedPlants.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보관함'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: harvestedPlants.length,
              itemBuilder: (context, index) {
                final plant = harvestedPlants[index];
                final isSelected = selectedPlants.contains(index);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: isSelected ? Colors.brown[100] : null,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        _toggleSelection(index);
                      },
                    ),
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
                        Text('수량: ${plant.quantity}개'),
                        Text('수확일: ${plant.harvestDate.toString().split(' ')[0]}'),
                      ],
                    ),
                    onTap: () => _toggleSelection(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _deliverSelectedPlants,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                '선택한 식물 배송하기',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 