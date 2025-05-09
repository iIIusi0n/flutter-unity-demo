import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  final VoidCallback? onCameraPressed;

  const CameraOverlay({
    super.key,
    this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }
} 