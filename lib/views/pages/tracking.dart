import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TrackingScreen extends StatelessWidget {
  // const TrackingScreen({super.key});
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962), // Google HQ coordinates
    zoom: 14.4746,
  );

  TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Tracking')),
      body: GoogleMap(
        // Set your Map ID.
        // mapId: 'my-map-id',
        // Enable support for Advanced Markers.
        // markerType: GoogleMapMarkerType.advancedMarker,
        initialCameraPosition: _kGooglePlex,
      ),
    );
  }
}