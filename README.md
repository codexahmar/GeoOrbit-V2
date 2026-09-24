# Solaris

A high-fidelity, interactive 3D solar system and planetary encyclopedia built with Flutter. Designed with platform-native architectures for iOS (**Apple Cupertino**) and Android (**Material 3**).

---

## Highlights

- **3D Planetary Engine**: Interactive 360° celestial sphere with high-resolution textures across the Solar System (*Sun, Mercury, Venus, Earth, Moon, Mars, Jupiter, Saturn, Uranus, Neptune*).
- **True Platform-Native UI**:
  - **iOS**: Apple Cupertino design language featuring Inset Grouped lists, frosted navigation bars, SF Symbols, and modal action sheets.
  - **Android**: Modern Material 3 interface with dynamic surfaces, adaptive elevation, and bottom sheets.
- **Waypoints & Flight Paths**: Real-time ground coordinates, interactive focus transitions, and animated sub-orbital trajectory arcs.
- **Adaptive Layout**: Multi-pane workstation view on tablets/desktops and an optimized viewport on mobile devices.
- **Hardware-Accelerated**: 60 FPS rendering with reactive state management.

---

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart 3)
- **3D Sphere Engine**: [`flutter_earth_globe`](https://pub.dev/packages/flutter_earth_globe)
- **State Management**: [`provider`](https://pub.dev/packages/provider)
- **Design Systems**: Apple Cupertino / Google Material 3

---

## Quick Start

### Prerequisites
- Flutter SDK `^3.0.0`
- Dart SDK `^3.0.0`

### Run Locally

```bash
# Clone the repository
git clone https://github.com/codexahmar/SolarSystem-3D.git
cd SolarSystem-3D

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/       # Breakpoints & design constants
│   └── theme/           # Cupertino & Material 3 theme configurations
├── data/
│   ├── models/          # Celestial body & location data models
│   └── repositories/    # Geo coordinates & flight connection data
├── presentation/
│   ├── providers/       # GlobeProvider state management
│   ├── screens/         # HomeScreen (responsive adaptive layout)
│   └── widgets/         # 3D globe viewport, control panel & texture selector
└── utils/               # Platform detection & animation helpers
```

---

## Author

**Ahmaryar Khan** — [@codexahmar](https://github.com/codexahmar)

---

## License

This project is licensed under the [MIT License](LICENSE).
