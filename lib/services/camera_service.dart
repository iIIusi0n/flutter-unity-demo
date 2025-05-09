import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  static Future<CameraController?> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return null;

    final controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller.initialize();
    return controller;
  }

  static Future<String?> captureAndEncodeImage(CameraController controller) async {
    try {
      final XFile image = await controller.takePicture();
      final bytes = await image.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint('Error capturing image: $e');
      return null;
    }
  }

  static Future<bool> uploadImage(String base64Image) async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_SERVER_ENDPOINT'), // Replace with your actual server endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return false;
    }
  }
} 