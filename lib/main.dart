import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter/services.dart';
import 'widgets/game_controls.dart';
import 'screens/plants_info_screen.dart';
import 'screens/storage_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    const MaterialApp(
      home: UnityDemoScreen(),
    ),
  );
}

class UnityDemoScreen extends StatefulWidget {
  const UnityDemoScreen({super.key});

  @override
  State<UnityDemoScreen> createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;
  bool _isUnityReady = false;

  void _showPlantsInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SizedBox(
        height: 600,
        child: PlantsInfoScreen(),
      ),
    );
  }

  void _showStorage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SizedBox(
        height: 600,
        child: StorageScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: PopScope(
          canPop: true,
          child: Stack(
            children: [
              Container(
                color: Colors.yellow,
                child: UnityWidget(
                  onUnityCreated: onUnityCreated,
                  onUnityMessage: onUnityMessage,
                ),
              ),
              if (_isUnityReady)
                GameControls(
                  onCameraPressed: () {
                    // TODO: Implement camera functionality
                  },
                  onStorePressed: () {
                    // TODO: Implement store functionality
                  },
                  onPlantsInfoPressed: _showPlantsInfo,
                  onStoragePressed: _showStorage,
                  notificationCount: 2,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  // Callback that receives messages from Unity
  void onUnityMessage(dynamic message) {
    if (message is String && message == 'UnityReady') {
      setState(() {
        _isUnityReady = true;
      });
    }
  }
}