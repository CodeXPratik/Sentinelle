import 'package:flutter/material.dart';
import '../pages/sos_active.dart';

class SosFab extends StatelessWidget {
  final double top;
  final double? right;
  final double? left;

  const SosFab({super.key, required this.top, this.right = 20, this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SosActiveScreen()),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFE0000),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFE0000).withValues(alpha: 0.4),
                blurRadius: 30,
              ),
            ],
          ),
          child: const Icon(
            Icons.emergency_share,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
