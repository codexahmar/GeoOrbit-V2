import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/sphere_style.dart';
import '../../data/models/celestial_body_model.dart';
import '../../core/constants/app_constants.dart';

class GlobeProvider extends ChangeNotifier {
  late FlutterEarthGlobeController _controller;

  CelestialBodyModel _selectedBody = CelestialBodyModel.allBodies.firstWhere(
    (b) => b.id == 'earth',
    orElse: () => CelestialBodyModel.allBodies[0],
  );

  bool _isInitialized = false;

  // Getters
  FlutterEarthGlobeController get controller => _controller;
  CelestialBodyModel get selectedBody => _selectedBody;
  List<CelestialBodyModel> get allBodies => CelestialBodyModel.allBodies;
  bool get isInitialized => _isInitialized;

  // ---------------- Initialization ----------------

  void initialize() {
    if (_isInitialized) return;

    _controller = FlutterEarthGlobeController(
      rotationSpeed: AppConstants.defaultRotationSpeed,
      zoom: AppConstants.defaultZoom,
      isRotating: true,
      isBackgroundFollowingSphereRotation: true,
      background: Image.asset('assets/2k_stars.jpg').image,
      surface: Image.asset(_selectedBody.texturePath).image,
    );

    _isInitialized = true;
    notifyListeners();

    _controller.onLoaded = () {
      _applyGlow();
    };
  }

  // ---------------- Celestial Body Selection ----------------

  void selectCelestialBody(CelestialBodyModel body) {
    if (_selectedBody.id == body.id) return;
    _selectedBody = body;

    _controller.loadSurface(Image.asset(body.texturePath).image);
    _applyGlow();

    notifyListeners();
  }

  void _applyGlow() {
    if (_selectedBody.hasGlow) {
      _controller.setSphereStyle(
        SphereStyle(
          shadowColor: _selectedBody.glowColor!.withOpacity(0.85),
          shadowBlurSigma: _selectedBody.glowIntensity!,
        ),
      );
    } else {
      _controller.setSphereStyle(const SphereStyle());
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      try {
        _controller.dispose();
      } catch (_) {}
    }
    super.dispose();
  }
}
