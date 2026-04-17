import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widget_tree.dart';
import '../widgets/glass_conatiner.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/sos_fab.dart';

class TrackingScreen extends StatefulWidget {
  final bool isMapBackground;

  const TrackingScreen({super.key, this.isMapBackground = false});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  static const LatLng _initialLocation = LatLng(
    48.8566,
    2.3522,
  ); // Paris coordinates
  bool _isReporting = false;
  final TextEditingController _reportController = TextEditingController();
  String _selectedCategory = 'Harassment';

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Harassment', 'icon': Icons.person_off},
    {'label': 'Poor Lighting', 'icon': Icons.light_mode},
    {'label': 'Suspicious Activity', 'icon': Icons.visibility},
    {'label': 'Physical Threat', 'icon': Icons.warning_amber_rounded},
    {'label': 'Medical Emergency', 'icon': Icons.medical_services},
    {'label': 'Theft', 'icon': Icons.inventory_2},
    {'label': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isMapBackground
          ? Colors.transparent
          : const Color(0xFF0E0E0E),
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'SENTINELLE',
        subtitle: 'User Profile', // DEVELOPER: Replace with dynamic user name
        onSearchPressed: () {
          WidgetTree.of(context)?.setSelectedIndex(0, focusSearch: true);
        },
      ),
      body: Stack(
        children: [
          // Background Map (Only show if not using global background)
          if (!widget.isMapBackground)
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _initialLocation,
                  zoom: 14.0,
                ),
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                style: _darkMapStyle,
              ),
            ),

          // Gradient Overlays
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0E0E0E).withValues(alpha: 0.8),
                      Colors.transparent,
                      const Color(0xFF0E0E0E).withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // SOS FAB
          const SosFab(top: 190),

          // Report Button
          Positioned(
            top: 260,
            right: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isReporting = !_isReporting;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _isReporting
                      ? const Color(0xFFD692FF)
                      : const Color(0xFF262626),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: _isReporting
                          ? const Color(0xFFD692FF).withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Icon(
                  _isReporting ? Icons.close : Icons.report_problem,
                  color: _isReporting ? Colors.black : const Color(0xFFD692FF),
                  size: 28,
                ),
              ),
            ),
          ),

          // Bottom Navigation Panel
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.25,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 110),
                  child: GlassContainer(
                    borderRadius: 40,
                    opacity: 0.8,
                    child: _isReporting
                        ? _buildReportContent(scrollController)
                        : _buildRouteContent(scrollController),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRouteContent(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 140),
      children: [
        Center(
          child: Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-- mins',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                Text(
                  '-- km via --',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF4ADE80).withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Text(
                    'PRIMARY ROUTE',
                    style: TextStyle(
                      color: Color(0xFF4ADE80),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ETA --:--',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        const Center(
          child: Text(
            'Select a destination to see route details',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD692FF), Color(0xFFAF25FE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFAF25FE).withValues(alpha: 0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'INITIATE GUARDIAN MODE',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.bolt, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportContent(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 140),
      children: [
        Center(
          child: Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'REPORT ANOMALY',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Space Grotesk',
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your report helps the community stay safe. AI-driven nodes will verify and broadcast this anomaly.',
          style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 32),
        const Text(
          'SELECT CATEGORY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Color(0xFFD692FF),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories
              .map((cat) => _buildCategoryChip(cat['label'], cat['icon']))
              .toList(),
        ),
        const SizedBox(height: 32),
        const Text(
          'SITUATION DETAILS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Color(0xFFD692FF),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: _reportController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText:
                  'Describe the threat, individual, or environment issue in detail...',
              hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFE0000), Color(0xFFAF0000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFE0000).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isReporting = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Anomaly Report Broadcasted to Nearby Sentinels',
                  ),
                  backgroundColor: Color(0xFF4ADE80),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BROADCAST REPORT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.radar, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD692FF)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD692FF)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.black : const Color(0xFFD692FF),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final String? _darkMapStyle = null;
}
