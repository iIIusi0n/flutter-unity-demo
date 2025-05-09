import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final controller = await CameraService.initializeCamera();
    if (controller != null) {
      setState(() {
        _controller = controller;
        _isInitialized = true;
      });
    }
  }

  Future<void> _captureAndUpload() async {
    if (_controller == null || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      final base64Image = await CameraService.captureAndEncodeImage(_controller!);
      if (base64Image != null) {
        Navigator.pop(context); // Return to main screen
        _showAnalysisModal(context, base64Image);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _showAnalysisModal(BuildContext context, String base64Image) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AnalysisModal(base64Image: base64Image),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final scale = 1 / (_controller!.value.aspectRatio * size.aspectRatio);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(_controller!),
            ),
          ),
          if (_isCapturing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                GestureDetector(
                  onTap: _isCapturing ? null : _captureAndUpload,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisModal extends StatefulWidget {
  final String base64Image;

  const _AnalysisModal({required this.base64Image});

  @override
  State<_AnalysisModal> createState() => _AnalysisModalState();
}

class _AnalysisModalState extends State<_AnalysisModal> {
  bool _isUploading = true;
  bool _isAnalyzing = false;
  AnalysisResult? _analysisResult;
  String? _error;
  int? _analysisId;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    try {
      _analysisId = await CameraService.uploadImage(widget.base64Image);
      if (_analysisId != null) {
        setState(() {
          _isUploading = false;
          _isAnalyzing = true;
        });
        _pollAnalysisResult();
      } else {
        setState(() {
          _error = 'Failed to upload image';
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isUploading = false;
      });
    }
  }

  Future<void> _pollAnalysisResult() async {
    while (mounted && _analysisId != null) {
      final result = await CameraService.getAnalysisResult(_analysisId!);
      if (result != null) {
        setState(() {
          _analysisResult = result;
          _isAnalyzing = false;
        });
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isUploading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                'Uploading image...',
                style: TextStyle(fontSize: 18),
              ),
            ] else if (_isAnalyzing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                'Analyzing plant...',
                style: TextStyle(fontSize: 18),
              ),
            ] else if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ] else if (_analysisResult != null) ...[
              Text(
                _analysisResult!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Water every ${_analysisResult!.daysBetweenWater} days',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Ready to harvest in ${_analysisResult!.daysToMaturity} days',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 