import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _currentAlertId;

  User? getCurrentUser() => _auth.currentUser;
  
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> startEmergency(Position position) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // 1. Fetch emergency contacts from Firestore
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final List<dynamic> contacts = userDoc.data()?['emergency_contacts'] ?? [];

    // 2. Create an alert record in Firestore
    final alertRef = await _firestore.collection('alerts').add({
      'userId': user.uid,
      'userName': user.displayName ?? 'Sentinelle User',
      'userEmail': user.email,
      'status': 'active',
      'startTime': FieldValue.serverTimestamp(),
      'initialLocation': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'emergencyContacts': contacts,
    });

    _currentAlertId = alertRef.id;

    // 3. Start live tracking in Realtime Database
    await _database.ref('live_alerts/$_currentAlertId').set({
      'userId': user.uid,
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'lastUpdate': ServerValue.timestamp,
      'status': 'active',
    });

    // 4. Send SMS to all contacts
    await _sendEmergencySMS(contacts, position);
  }

  Future<void> _sendEmergencySMS(List<dynamic> contacts, Position position) async {
    if (contacts.isEmpty) return;

    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    final String message = 'EMERGENCY SOS: I need help! My location: $googleMapsUrl';

    // Clean numbers but strictly preserve the '+'
    final List<String> phoneNumbers = contacts
        .map((c) => c['phone']?.toString().replaceAll(RegExp(r'[^\d+]'), '') ?? '')
        .where((p) => p.isNotEmpty)
        .toList();

    if (phoneNumbers.isEmpty) return;

    // Join recipients with a comma
    final String recipients = phoneNumbers.join(',');

    // We use a raw string here because the Uri constructor encodes '+' as '%2B',
    // which many SMS apps do not recognize as a valid country code prefix.
    final String uriString = 'sms:$recipients?body=${Uri.encodeComponent(message)}';
    final Uri smsUri = Uri.parse(uriString);

    debugPrint('Launching SOS SMS: $uriString');

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback for extreme cases: try to launch the first number only
        final String firstRecipient = phoneNumbers.first;
        final Uri fallbackUri = Uri.parse('sms:$firstRecipient?body=${Uri.encodeComponent(message)}');
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching SMS: $e');
    }
  }

  Future<void> updateLiveLocation(Position position) async {
    if (_currentAlertId == null) return;

    await _database.ref('live_alerts/$_currentAlertId/location').update({
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
    await _database.ref('live_alerts/$_currentAlertId').update({
      'lastUpdate': ServerValue.timestamp,
    });
  }

  Future<void> stopEmergency() async {
    if (_currentAlertId == null) return;

    await _firestore.collection('alerts').doc(_currentAlertId).update({
      'status': 'resolved',
      'endTime': FieldValue.serverTimestamp(),
    });

    await _database.ref('live_alerts/$_currentAlertId').update({
      'status': 'resolved',
    });

    _currentAlertId = null;
  }
}
