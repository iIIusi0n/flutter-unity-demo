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
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 60, 155, 65).withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: onCameraPressed,
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 28,
                  color: Color(0xFFE8F5E9),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 156,
          left: 20,
          child: Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8F5E9).withOpacity(0.85),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: onPlantsInfoPressed,
                    child: const Icon(
                      Icons.eco_rounded,
                      size: 32,
                      color: Color.fromARGB(255, 60, 155, 65),
                    ),
                  ),
                ),
              ),
              if (notificationCount != null && notificationCount! > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
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
                ),
            ],
          ),
        ),
        Positioned(
          top: 80,
          right: 20,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 76, 175, 80).withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: onStorePressed,
                child: const Icon(
                  Icons.store_rounded,
                  size: 28,
                  color: Color(0xFFF1F8E9),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 