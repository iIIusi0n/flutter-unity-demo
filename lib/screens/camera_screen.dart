import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
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
  Image? _capturedImage;

  // List of valid plants
  static const List<String> validPlants = [
    '토마토',
    '딸기',
    '상추',
    '당근',
    '옥수수',
    '고추',
  ];

  @override
  void initState() {
    super.initState();
    _decodeImage();
    _startAnalysis();
  }

  void _decodeImage() {
    try {
      final bytes = base64Decode(widget.base64Image);
      _capturedImage = Image.memory(bytes);
    } catch (e) {
      print('Error decoding image: $e');
    }
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
          _error = '이미지 업로드에 실패했습니다';
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = '오류: $e';
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

  void _showPlantingConfirmation() {
    final bool isValidPlant = validPlants.contains(_analysisResult!.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('식물 심기'),
        content: Text(
          isValidPlant
              ? '${_analysisResult!.name}을(를) 심으시겠습니까?'
              : '${_analysisResult!.name}은(는) 심을 수 있지만 배송받지 못하는 식물입니다. 심으시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close analysis modal
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement planting logic
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close analysis modal
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isValidPlant
                        ? '식물이 성공적으로 심어졌습니다!'
                        : '${_analysisResult!.name}이(가) 심어졌습니다. (배송 불가)',
                  ),
                  backgroundColor: isValidPlant ? Colors.green : Colors.orange,
                ),
              );
            },
            child: const Text('심기'),
          ),
        ],
      ),
    );
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
                '이미지 업로드 중...',
                style: TextStyle(fontSize: 18),
              ),
            ] else if (_isAnalyzing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                '식물 분석 중...',
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
                child: const Text('닫기'),
              ),
            ] else if (_analysisResult != null) ...[
              if (_capturedImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: _capturedImage,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Text(
                _analysisResult!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${_analysisResult!.daysBetweenWater}일마다 물주기',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                '${_analysisResult!.daysToMaturity}일 후 수확 가능',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('닫기'),
                  ),
                  ElevatedButton(
                    onPressed: _showPlantingConfirmation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('식물 심기'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
} 