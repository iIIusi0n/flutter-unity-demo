import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback? onCameraPressed;
  final VoidCallback? onPlantsInfoPressed;
  final VoidCallback? onStorePressed;
  final int? notificationCount;

  const GameControls({
    super.key,
    this.onCameraPressed,
    this.onPlantsInfoPressed,
    this.onStorePressed,
    this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 80,
          left: 20,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCameraPressed,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 140,
          left: 20,
          child: Stack(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPlantsInfoPressed,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.eco_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (notificationCount != null && notificationCount! > 0)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 80,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onStorePressed,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.store_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 