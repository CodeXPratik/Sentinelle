import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/glass_conatiner.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  // Target position (Google Headquarters for testing)
  static const LatLng _targetLocation = LatLng(37.42796133580664, -122.085749655962);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Tracking'),


      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          child: Center(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: _targetLocation,
                zoom: 15.0,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId('target_position'),
                  position: _targetLocation,
                  infoWindow: InfoWindow(
                    title: 'Target Location',
                    snippet: 'Destination Point',
                  ),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
        ),
      ),
    );

  }
}
