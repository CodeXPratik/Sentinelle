import 'package:flutter/material.dart';
import '../widgets/glass_conatiner.dart';
import '../widgets/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: const CustomAppBar(
        title: 'SENTINELLE',
        subtitle: 'User Profile', // DEVELOPER: Replace with dynamic user name
        showSearch: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderContext(),
              const SizedBox(height: 40),
              _buildEmergencyContacts(),
              const SizedBox(height: 40),
              _buildPreferencesGrid(),
              const SizedBox(height: 24),
              _buildStorageHUD(),
              const SizedBox(height: 120), // Bottom spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContext() {
    return GlassContainer(
      borderRadius: 32,
      opacity: 0.7,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Security Settings',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your protective protocols and digital footprint.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFD692FF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD692FF).withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD692FF).withValues(alpha: 0.15),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield,
                color: Color(0xFFD692FF),
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'Emergency Contacts',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD692FF),
              ),
            ),
            Text(
              'ADD NEW',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.4),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildContactCard(
          name: 'Primary Contact',
          // DEVELOPER: Replace with dynamic contact name
          relation: 'Primary • +1 (555) 000-00',
          icon: Icons.person_pin,
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          name: 'Secondary Contact',
          // DEVELOPER: Replace with dynamic contact name
          relation: 'Guardian • +1 (555) 000-00',
          icon: Icons.person_pin_circle,
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required String name,
    required String relation,
    required IconData icon,
  }) {
    return GlassContainer(
      borderRadius: 24,
      opacity: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Icon(icon, color: const Color(0xFFD692FF), size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      relation,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD692FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFD692FF).withValues(alpha: 0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, size: 14, color: Color(0xFFD692FF)),
                  SizedBox(width: 4),
                  Text(
                    'VERIFIED',
                    style: TextStyle(
                      color: Color(0xFFD692FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: GlassContainer(
                borderRadius: 32,
                opacity: 0.1,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF191919),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.language,
                              color: Color(0xFFD692FF),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Language Preferences',
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildLanguageOption('English (US)', true),
                      const SizedBox(height: 12),
                      _buildLanguageOption('Français (FR)', false),
                      const SizedBox(height: 12),
                      _buildLanguageOption('Español (ES)', false),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassContainer(
          borderRadius: 32,
          opacity: 0.1,
          color: const Color(0xFF191919),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF191919),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.cloud_off, color: Color(0xFFD692FF)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Offline Data Management',
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Store local maps and emergency protocols.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: true,
                  onChanged: (v) {},
                  activeThumbColor: const Color(0xFFD692FF),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFD692FF).withValues(alpha: 0.1)
            : const Color(0xFF131313),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? const Color(0xFFD692FF).withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD692FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Icon(
            isActive ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isActive
                ? const Color(0xFFD692FF)
                : Colors.white.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageHUD() {
    return GlassContainer(
      borderRadius: 32,
      opacity: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Secure Cache',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '3.2 GB of local safety data stored.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF262626),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.65,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD692FF),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFD692FF,
                                ).withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF262626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'CLEAR CACHE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
