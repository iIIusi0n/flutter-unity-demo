import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import '../screens/camera_screen.dart';

class GameControls extends StatefulWidget {
  final VoidCallback? onCameraPressed;
  final VoidCallback? onPlantsInfoPressed;
  final VoidCallback? onStorePressed;
  final VoidCallback? onStoragePressed;
  final VoidCallback? onHarvestPressed;
  final VoidCallback? onWateringPressed;
  final int? notificationCount;
  final Function(StickDragDetails)? onJoystickChanged;

  const GameControls({
    super.key,
    this.onCameraPressed,
    this.onPlantsInfoPressed,
    this.onStorePressed,
    this.onStoragePressed,
    this.onHarvestPressed,
    this.onWateringPressed,
    this.notificationCount,
    this.onJoystickChanged,
  });

  @override
  State<GameControls> createState() => _GameControlsState();
}

class _GameControlsState extends State<GameControls> {
  double _sliderValue = 0.5;

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                );
              },
              customBorder: const CircleBorder(),
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
                  onTap: widget.onPlantsInfoPressed,
                  customBorder: const CircleBorder(),
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
              if (widget.notificationCount != null && widget.notificationCount! > 0)
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
                      widget.notificationCount.toString(),
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
          top: 200,
          left: 20,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onStoragePressed,
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.warehouse_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onStorePressed,
              customBorder: const CircleBorder(),
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
        Positioned(
          bottom: 70,
          left: 40,
          child: SizedBox(
            width: 120,
            height: 120,
            child: Joystick(
              mode: JoystickMode.all,
              period: const Duration(milliseconds: 50),
              listener: (details) {
                if (widget.onJoystickChanged != null) {
                  widget.onJoystickChanged!(details);
                }
              },
              base: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),
              stick: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 40,
          child: SizedBox(
            width: 160,
            height: 180,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onHarvestPressed,
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.4),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.agriculture_rounded,
                          size: 48,
                          color: Colors.amber.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onWateringPressed,
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.4),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.water_drop_rounded,
                          size: 48,
                          color: Colors.blue.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 16,
          top: 200,
          bottom: 200,
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              width: 200,
              child: Slider(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
                activeColor: Colors.white.withOpacity(0.3),
                inactiveColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 