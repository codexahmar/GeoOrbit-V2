import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
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
  bool get isRotating => _isInitialized ? _controller.isRotating : true;
  double get rotationSpeed => _isInitialized ? _controller.rotationSpeed : AppConstants.defaultRotationSpeed;
  double get zoom => _isInitialized ? _controller.zoom : AppConstants.defaultZoom;

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

  // ---------------- Rotation & Zoom Controls ----------------

  void toggleRotation() {
    if (_controller.isRotating) {
      _controller.stopRotation();
    } else {
      _controller.startRotation();
    }
    notifyListeners();
  }

  void resetRotation() {
    _controller.resetRotation();
    _controller.focusOnCoordinates(const GlobeCoordinates(0, 0), animate: true);
    notifyListeners();
  }

  void setRotationSpeed(double speed) {
    _controller.rotationSpeed = speed.clamp(
      AppConstants.minRotationSpeed,
      AppConstants.maxRotationSpeed,
    );
    notifyListeners();
  }

  void setZoom(double zoom) {
    _controller.setZoom(zoom.clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    ));
    notifyListeners();
  }

  void zoomIn() {
    setZoom(_controller.zoom + 0.15);
  }

  void zoomOut() {
    setZoom(_controller.zoom - 0.15);
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
