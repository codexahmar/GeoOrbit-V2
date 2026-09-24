import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Checks if the active target platform is Apple iOS
bool isIOSPlatform(BuildContext context) {
  if (kIsWeb) {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }
  return Theme.of(context).platform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.iOS;
}

/// Helpful responsive and formatting utilities
class Helpers {
  // Responsive font size utility
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return baseSize * 0.9;
    } else if (width < 900) {
      return baseSize;
    } else {
      return baseSize * 1.1;
    }
  }

  // Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
