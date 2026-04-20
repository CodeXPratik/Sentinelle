import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sentinelle/views/pages/sos_active.dart';
import 'pages/dashboard.dart';
import 'pages/tracking.dart';
import 'pages/safety_tips.dart';
import 'pages/settings.dart';
import 'widgets/glass_conatiner.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  static _WidgetTreeState? of(BuildContext context) =>
      context.findAncestorStateOfType<_WidgetTreeState>();

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  int _selectedIndex = 0;
  bool _shouldFocusSearch = false;
  CameraPosition _currentCameraPosition = const CameraPosition(
    target: LatLng(48.8566, 2.3522),
    zoom: 14.0,
  );

  void setSelectedIndex(int index, {bool focusSearch = false}) {
    setState(() {
      _selectedIndex = index;
      _shouldFocusSearch = focusSearch;
    });
  }

  bool consumeFocusSearch() {
    if (_shouldFocusSearch) {
      _shouldFocusSearch = false;
      return true;
    }
    return false;
  }

  void updateCameraPosition(CameraPosition position) {
    _currentCameraPosition = position;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Global Background Map
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _currentCameraPosition,
              onCameraMove: (position) => _currentCameraPosition = position,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
            ),
          ),

          // Pages on top of the map
          IndexedStack(
            index: _selectedIndex,
            children: [
              const DashboardScreen(isMapBackground: true),
              const TrackingScreen(isMapBackground: true),
              const SafetyTipsScreen(),
              const SettingsScreen(),
              const SosActiveScreen(isMapBackground: true),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _selectedIndex == 4
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
              child: GlassContainer(
                borderRadius: 30,
                opacity: 0.7,
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(0, Icons.home, 'Home'),
                      _buildNavItem(1, Icons.map, 'Routes'),
                      _buildNavItem(2, Icons.lightbulb, 'Tips'),
                      _buildNavItem(3, Icons.settings, 'Settings'),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD692FF).withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFD692FF) : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFD692FF) : Colors.white54,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
