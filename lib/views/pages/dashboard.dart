import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/glass_conatiner.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/sos_fab.dart';
import '../widgets/alert_card.dart';
import '../widgets/quick_zone_chip.dart';
import '../widget_tree.dart';

class DashboardScreen extends StatefulWidget {
  final bool isMapBackground;

  const DashboardScreen({super.key, this.isMapBackground = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const LatLng _initialLocation = LatLng(
    48.8566,
    2.3522,
  ); // Paris coordinates
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (WidgetTree.of(context)?.consumeFocusSearch() ?? false) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isMapBackground
          ? Colors.transparent
          : const Color(0xFF0E0E0E),
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: 'SENTINELLE',
        subtitle: 'User Profile', // DEVELOPER: Replace with dynamic user name
        showSearch: false,
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

          // Search Bar
          Positioned(
            top: 135,
            left: 20,
            right: 20,
            child: GlassContainer(
              borderRadius: 16,
              opacity: 0.8,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _searchFocusNode.requestFocus(),
                      child: const Icon(
                        Icons.travel_explore,
                        color: Colors.white54,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Search safe zones...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          WidgetTree.of(context)?.setSelectedIndex(1);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD692FF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text(
                        'FIND',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // SOS FAB
          const SosFab(top: 210),

          // Bottom Content Panel
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
                    child: _buildDashboardContent(scrollController),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(ScrollController scrollController) {
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
          'QUICK SAFE ZONES',
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
          'Instant access to 24/7 monitored safety nodes and verified medical facilities.',
          style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 32),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const QuickZoneChip(
                icon: Icons.local_hospital,
                label: 'Hospitals',
              ),
              const SizedBox(width: 12),
              const QuickZoneChip(icon: Icons.local_police, label: 'Police'),
              const SizedBox(width: 12),
              const QuickZoneChip(
                icon: Icons.night_shelter,
                label: '24/7 Shelters',
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'NEARBY ALERTS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Color(0xFFD692FF),
          ),
        ),
        const SizedBox(height: 16),
        const AlertCard(
          icon: Icons.warning,
          color: Color(0xFFFF725E),
          title: 'Protest Nearby',
          time: '2 mins ago',
          description:
              'Large gathering reported at Central Square. Rerouting recommended.',
        ),
        const SizedBox(height: 16),
        const AlertCard(
          icon: Icons.construction,
          color: Color(0xFFD692FF),
          title: 'Road Construction',
          time: '15 mins ago',
          description:
              'Main St. closed for maintenance. Sidewalk access restricted.',
        ),
        const SizedBox(height: 16),
        const AlertCard(
          icon: Icons.lightbulb,
          color: Colors.white54,
          title: 'Safe Route Tip',
          time: '1h ago',
          description:
              'Park Avenue is currently well-lit and monitored by Sentinel nodes.',
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
