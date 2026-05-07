import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../widgets/custom_app_bar.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'SENTINELLE',
        subtitle: FirebaseAuth.instance.currentUser?.displayName ??
            FirebaseAuth.instance.currentUser?.email ??
            'Sentinelle User',
        showSearch: false,
      ),
      body: Stack(
        children: [
          // Background Gradient Blob
          Positioned(
            top: 100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4ADE80).withValues(alpha: 0.05),
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
              children: [
                const Text(
                  'SAFETY PROTOCOLS',
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
                  'Expert-vetted intelligence for urban navigation and emergency preparedness.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                _buildFeaturedTip(),
                const SizedBox(height: 32),

                _buildSectionHeader('ESSENTIAL GUIDELINES'),
                const SizedBox(height: 16),
                _buildTipCard(
                  icon: Icons.share_location,
                  title: 'Real-time Tethering',
                  description:
                      'Always keep your live location shared with at least two trusted contacts through the "Guardian Mode" feature.',
                  color: const Color(0xFFD692FF),
                ),
                _buildTipCard(
                  icon: Icons.nightlight_round,
                  title: 'Nocturnal Awareness',
                  description:
                      'When traveling at night, prioritize routes labeled "AI VERIFIED" with a safety score above 85.',
                  color: const Color(0xFFFBBF24),
                ),
                _buildTipCard(
                  icon: Icons.phone_android,
                  title: 'Device Readiness',
                  description:
                      'Ensure your device has at least 30% battery before initiating a solo trek. Carry a portable power bank.',
                  color: const Color(0xFF4ADE80),
                ),
                _buildTipCard(
                  icon: Icons.visibility,
                  title: 'Situational Vigilance',
                  description:
                      'Avoid using headphones in unfamiliar zones. High situational awareness reduces risk by 70%.',
                  color: const Color(0xFFFE0000),
                ),

                const SizedBox(height: 32),
                _buildSectionHeader('EMERGENCY CONTACTS'),
                const SizedBox(height: 16),
                _buildEmergencyContact(
                  'LOCAL POLICE',
                  '112',
                  Icons.local_police,
                ),
                _buildEmergencyContact(
                  'AMBULANCE',
                  '15',
                  Icons.medical_services,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        color: Color(0xFFD692FF),
      ),
    );
  }

  Widget _buildFeaturedTip() {
    return GlassContainer(
      borderRadius: 24,
      color: const Color(0xFFD692FF),
      opacity: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD692FF).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'PRO TIP',
                style: TextStyle(
                  color: Color(0xFFD692FF),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Utilize the "Safe Haven" filter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enable this filter on your map to see 24/7 monitored establishments where you can seek immediate refuge.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: 20,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContact(String label, String number, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: 16,
        opacity: 0.3,
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFFFE0000)),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          trailing: Text(
            number,
            style: const TextStyle(
              color: Color(0xFFFE0000),
              fontWeight: FontWeight.w900,
              fontSize: 18,
              fontFamily: 'Space Grotesk',
            ),
          ),
        ),
      ),
    );
  }
}
