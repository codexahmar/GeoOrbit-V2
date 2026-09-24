import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/point_connection.dart';
import 'package:flutter_earth_globe/sphere_style.dart';
import '../../data/models/location_model.dart';
import '../../data/models/celestial_body_model.dart';
import '../../data/repositories/globe_repository.dart';
import '../../core/constants/app_constants.dart';

class GlobeProvider extends ChangeNotifier {
  final GlobeRepository _repository = GlobeRepository();
  late FlutterEarthGlobeController _controller;

  List<LocationModel> _locations = [];
  List<PointConnection> _connections = [];
  CelestialBodyModel? _selectedBody;
  GlobeCoordinates? _hoverCoordinates;
  GlobeCoordinates? _clickCoordinates;
  bool _isInitialized = false;
  bool _showConnections = true;
  bool _showLabels = true;
  bool _isTourMode = false;
  Timer? _tourTimer;

  FlutterEarthGlobeController get controller => _controller;
  List<LocationModel> get locations => _locations;
  List<PointConnection> get connections => _connections;
  CelestialBodyModel? get selectedBody => _selectedBody;
  GlobeCoordinates? get hoverCoordinates => _hoverCoordinates;
  GlobeCoordinates? get clickCoordinates => _clickCoordinates;
  bool get isInitialized => _isInitialized;
  bool get isRotating => _controller.isRotating;
  double get rotationSpeed => _controller.rotationSpeed;
  double get zoom => _controller.zoom;
  bool get showConnections => _showConnections;
  bool get showLabels => _showLabels;
  bool get isTourMode => _isTourMode;

  // ---------------- Initialization ----------------

  void initialize() {
    if (_isInitialized) return;

    _controller = FlutterEarthGlobeController(
      rotationSpeed: AppConstants.defaultRotationSpeed,
      zoom: AppConstants.defaultZoom,
      isRotating: true,
      isBackgroundFollowingSphereRotation: true,
      background: Image.asset('assets/2k_stars.jpg').image,
      surface: Image.asset('assets/2k_earth-day.jpg').image,
    );

    _locations = _repository.getDefaultLocations();
    _connections = _repository.getDefaultConnections(_locations);
    _selectedBody = CelestialBodyModel.allBodies.first;

    _isInitialized = true;
    notifyListeners();

    _controller.onLoaded = () {
      if (_selectedBody?.id == 'earth') {
        _addAllPoints();
        _addAllConnections();
      }
    };
  }

  // ---------------- Private Helpers ----------------

  void _addAllPoints() {
    for (var location in _locations) {
      if (location.isVisible) {
        _controller.addPoint(location.toPoint());
      }
    }
  }

  void _addAllConnections() {
    if (_showConnections && _connections.isNotEmpty) {
      for (var connection in _connections) {
        _controller.addPointConnection(connection, animateDraw: true);
      }
    }
  }

  // ---------------- Controls ----------------

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
    setZoom(_controller.zoom + 0.1);
  }

  void zoomOut() {
    setZoom(_controller.zoom - 0.1);
  }

  // ---------------- Tour Mode Showcase ----------------

  void toggleTourMode() {
    _isTourMode = !_isTourMode;
    if (_isTourMode) {
      _startTour();
    } else {
      _stopTour();
    }
    notifyListeners();
  }

  void _startTour() {
    _tourTimer?.cancel();
    if (!_controller.isRotating) {
      _controller.startRotation();
    }
    _setTourSpeed();

    _tourTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      final all = CelestialBodyModel.allBodies;
      final currentIndex = all.indexWhere((b) => b.id == _selectedBody?.id);
      final nextIndex = (currentIndex + 1) % all.length;
      selectCelestialBody(all[nextIndex]);
    });
  }

  void _setTourSpeed() {
    _controller.rotationSpeed = 0.08;
  }

  void _stopTour() {
    _tourTimer?.cancel();
    _tourTimer = null;
    _isTourMode = false;
  }

  // ---------------- Location Management ----------------

  void toggleLocation(LocationModel location) {
    final index = _locations.indexWhere((l) => l.id == location.id);
    if (index == -1) return;

    final updated = _locations[index].copyWith(isVisible: !location.isVisible);
    _locations[index] = updated;

    if (_selectedBody?.id == 'earth') {
      if (updated.isVisible) {
        _controller.addPoint(updated.toPoint());
      } else {
        _controller.removePoint(updated.id);
      }
    }

    notifyListeners();
  }

  void updateLocationSize(String id, double size) {
    final index = _locations.indexWhere((l) => l.id == id);
    if (index == -1) return;

    final location = _locations[index];
    final updated = location.copyWith(size: size);
    _locations[index] = updated;

    if (location.isVisible) {
      _controller.updatePoint(
        id,
        style: PointStyle(color: location.color, size: size),
      );
    }
    notifyListeners();
  }

  void focusOnLocation(LocationModel location) {
    // If not currently earth, switch to earth first
    if (_selectedBody?.id != 'earth') {
      final earth = CelestialBodyModel.allBodies.firstWhere((b) => b.id == 'earth');
      selectCelestialBody(earth);
    }
    _controller.focusOnCoordinates(location.coordinates, animate: true);
  }

  // ---------------- Connections ----------------

  void toggleConnections() {
    _showConnections = !_showConnections;
    if (_showConnections) {
      _addAllConnections();
    } else {
      for (var conn in _connections) {
        _controller.removePointConnection(conn.id);
      }
    }
    notifyListeners();
  }

  // ---------------- Celestial Body Selection ----------------

  void selectCelestialBody(CelestialBodyModel body) {
    final wasEarth = _selectedBody?.id == 'earth';
    final isEarth = body.id == 'earth';
    _selectedBody = body;

    _controller.loadSurface(Image.asset(body.texturePath).image);

    // Handle points
    if (wasEarth && !isEarth) {
      for (var l in _locations.where((l) => l.isVisible)) {
        _controller.removePoint(l.id);
      }
    } else if (!wasEarth && isEarth) {
      _addAllPoints();
    }

    // Handle connections
    if (wasEarth && !isEarth) {
      for (var c in _connections) {
        _controller.removePointConnection(c.id);
      }
    } else if (!wasEarth && isEarth) {
      _addAllConnections();
    }

    // Glow effect
    if (body.hasGlow) {
      _controller.setSphereStyle(
        SphereStyle(
          shadowColor: body.glowColor!.withOpacity(0.9),
          shadowBlurSigma: body.glowIntensity!,
        ),
      );
    } else {
      _controller.setSphereStyle(const SphereStyle());
    }

    notifyListeners();
  }

  // ---------------- Interaction ----------------

  void setHoverCoordinates(GlobeCoordinates? coordinates) {
    _hoverCoordinates = coordinates;
    notifyListeners();
  }

  void setClickCoordinates(GlobeCoordinates? coordinates) {
    _clickCoordinates = coordinates;
    notifyListeners();
  }

  void toggleLabels() {
    _showLabels = !_showLabels;
    notifyListeners();
  }

  @override
  void dispose() {
    _tourTimer?.cancel();
    if (_isInitialized) {
      try {
        _controller.dispose();
      } catch (_) {}
    }
    super.dispose();
  }
}
