import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SosActiveScreen extends StatefulWidget {
  final bool isMapBackground;

  const SosActiveScreen({super.key, this.isMapBackground = false});

  @override
  State<SosActiveScreen> createState() => _SosActiveScreenState();
}

class _SosActiveScreenState extends State<SosActiveScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _timerController;
  int _secondsLeft = 5;
  Timer? _timer;
  LatLng _initialLocation = const LatLng(0, 0); // Default to (0,0) before fetch
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _determinePosition();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
        // Trigger emergency transmission logic here
      }
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_initialLocation, 15.0),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _timerController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isMapBackground
          ? Colors.transparent
          : const Color(0xFF0E0E0E),
      body: Stack(
        children: [
          // Background Map Backdrop
          if (!widget.isMapBackground)
            Positioned.fill(
              child: Opacity(
                opacity: 0.4,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialLocation,
                    zoom: 15.0,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),

          // Pulsating Emergency Layer
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                color: const Color(
                  0xFFFE0000,
                ).withValues(alpha: 0.1 + (_pulseController.value * 0.15)),
              );
            },
          ),

          // Grain Overlay (Optional - skipped for performance/complexity unless needed)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 48.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Status
                  _buildTopStatus(),

                  // Central HUD
                  _buildCentralHUD(),

                  // Indicators & Actions
                  _buildBottomSection(),
                ],
              ),
            ),
          ),

          // Decorative Edge Elements
          _buildDecorativeEdges(),
        ],
      ),
    );
  }

  Widget _buildTopStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFE0000),
                shape: BoxShape.circle,
              ),
            ).withAnimationPulse(),
            const SizedBox(width: 12),
            const Text(
              'EMERGENCY PROTOCOL ACTIVE',
              style: TextStyle(
                color: Color(0xFFFF725E),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'SENTINELLE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCentralHUD() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Rotating Ring
        RotationTransition(
          turns: _rotationController,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFE0000).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
        ),
        // Pulsing Ring
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFE0000).withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
            );
          },
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_secondsLeft',
              style: TextStyle(
                color: const Color(0xFFFF725E),
                fontSize: 120,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: const Color(0xFFFE0000).withValues(alpha: 0.5),
                    blurRadius: 25,
                  ),
                ],
              ),
            ),
            const Text(
              'SECONDS TO TRANSMISSION',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        // Grid Indicators
        Row(
          children: [
            Expanded(
              child: _buildIndicator(
                icon: Icons.mic,
                label: 'AUDIO RECORDING',
                status: 'ENCRYPTING...',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildIndicator(
                icon: Icons.share_location,
                label: 'LIVE TRACKING',
                status: 'BROADCASTING',
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Alert Button
        Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFE0000), Color(0xFFEB0000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFE0000).withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'ALERT AUTHORITIES NOW',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Automatic emergency dispatch will be triggered in 5 seconds. Sentinelle is currently sharing your location and live audio with your emergency contacts.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4),
        ),
        const SizedBox(height: 24),
        // Cancel Action
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'CANCEL SOS',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator({
    required IconData icon,
    required String label,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFE0000).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFF725E), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFFFF725E),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeEdges() {
    return Stack(
      children: [
        Positioned(
          top: 48,
          right: 32,
          child: Opacity(
            opacity: 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(width: 64, height: 2, color: const Color(0xFFFF725E)),
                const SizedBox(height: 4),
                Container(width: 32, height: 1, color: const Color(0xFFFF725E)),
                const SizedBox(height: 8),
                const Text(
                  'SECURE_LINK: E-4492',
                  style: TextStyle(
                    color: Color(0xFFFF725E),
                    fontSize: 8,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 48,
          left: 32,
          child: Opacity(
            opacity: 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'V_COORD: ${_initialLocation.latitude.toStringAsFixed(4)}° N, ${_initialLocation.longitude.toStringAsFixed(4)}° E',
                  style: const TextStyle(
                    color: Color(0xFFFF725E),
                    fontSize: 8,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: 64, height: 2, color: const Color(0xFFFF725E)),
                const SizedBox(height: 4),
                Container(width: 32, height: 1, color: const Color(0xFFFF725E)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension on Widget {
  Widget withAnimationPulse() {
    return _PulseAnimation(child: this);
  }
}

class _PulseAnimation extends StatefulWidget {
  final Widget child;

  const _PulseAnimation({required this.child});

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.5).animate(_controller),
      child: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.3).animate(_controller),
        child: widget.child,
      ),
    );
  }
}
