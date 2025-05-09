import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AnalysisResult {
  final String name;
  final int daysBetweenWater;
  final int daysToMaturity;
  final String? error;

  AnalysisResult({
    required this.name,
    required this.daysBetweenWater,
    required this.daysToMaturity,
    this.error,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      name: json['name'] ?? '',
      daysBetweenWater: json['days_between_water'] ?? 0,
      daysToMaturity: json['days_to_maturity'] ?? 0,
      error: json['error'],
    );
  }
}

class CameraService {
  static const String baseUrl = 'https://0dbe-180-71-27-252.ngrok-free.app/api'; // Replace with your server URL

  static Future<CameraController?> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return null;

    final controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
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

  static Future<int?> uploadImage(String base64Image) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analysis'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'encoded_image': base64Image,
        }),
      );

      if (response.statusCode == 202) {
        final data = jsonDecode(response.body);
        return data['id'] as int;
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  static Future<AnalysisResult?> getAnalysisResult(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/analysis/$id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AnalysisResult.fromJson(data);
      } else if (response.statusCode == 202) {
        // Analysis still in progress
        return null;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting analysis result: $e');
      return null;
    }
  }
} 