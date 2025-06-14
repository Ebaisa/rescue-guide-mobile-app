import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health/websocket/service.dart'; // Make sure this path is correct
import 'package:url_launcher/url_launcher.dart';

// Assuming this Hospital model is defined elsewhere, e.g., in a models folder
// Placeholder for your actual Hospital model


// IMPORTANT:
// If appNavigatorKey is defined in main.dart, you should import it:
// import 'package:health/main.dart' as app_main;
// Then use app_main.appNavigatorKey in places that need a global context
// However, since we're using _isMessageArrived and setState here,
// the global key for dialogs might become less critical,
// but it's still useful for global snackbars or navigation from outside this widget.
// For now, I'll assume appNavigatorKey is globally accessible or imported.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class HospitalScreen extends StatefulWidget {
  final String userId;

  const HospitalScreen({super.key, required this.userId});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  final HospitalService _hospitalService = HospitalService();
  List<Hospital> _hospitals = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // New state variables for message handling
  String? _dialogContent; // Stores the content for the dialog
  bool _isMessageArrived = false; // The flag to control dialog visibility

  @override
  void initState() {
    super.initState();
    debugPrint("HospitalScreen initState: UserID - ${widget.userId}");
    _connectWebSocket();
    _fetchHospitalsData();
  }

  @override
  void dispose() {
    _hospitalService.dispose(); // Ensure WebSocket connection is closed
    super.dispose();
  }

  Future<void> _fetchHospitalsData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final position = await _getCurrentLocationWithPermissions();
      if (position == null) {
        if (mounted) {
          setState(() {
            _errorMessage =
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : 'Unable to determine current location.';
            _isLoading = false;
          });
        }
        return;
      }

      debugPrint(
        "Fetching hospitals for Lat: ${position.latitude}, Lng: ${position.longitude}",
      );
      final fetchedHospitals = await _hospitalService.fetchNearestHospitals(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;
      if (fetchedHospitals.isEmpty) {
        setState(() {
          // Use a function for setState
          _errorMessage = 'No hospitals found near your location.';
          _hospitals = [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _hospitals = fetchedHospitals;
          _isLoading = false;
        });
      }
    } on SocketException {
      debugPrint("SocketException: No internet connection.");
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No internet connection. Please check your network.';
        _isLoading = false;
      });
    } on FormatException catch (e) {
      debugPrint("FormatException: Data format error - $e");
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error processing data. Please try again.';
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Exception fetching hospitals: $e");
      if (!mounted) return;
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
        _isLoading = false;
      });
    } finally {
      if (mounted && _errorMessage.isNotEmpty) {
        _showErrorSnackBar(_errorMessage);
      }
    }
  }

  Future<Position?> _getCurrentLocationWithPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) _errorMessage = 'Location services are disabled.';
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) _errorMessage = 'Location permissions are denied.';
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        _errorMessage =
            'Location permissions are permanently denied. Please enable them in app settings.';
      }
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint("Error getting current location: $e");
      if (mounted) _errorMessage = 'Error getting current location.';
      return null;
    }
  }

  void _connectWebSocket() {
    try {
      debugPrint("Connecting WebSocket for UserID: ${widget.userId}");
      _hospitalService.connectWebSocket(widget.userId);
      _hospitalService.notificationStream.listen(
        _handleWebSocketMessage,
        onError: (error) {
          debugPrint('WebSocket error: $error');
          if (mounted) {
            _showErrorSnackBar('WebSocket connection error.');
          }
        },
        onDone: () {
          debugPrint('WebSocket connection closed.');
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('Failed to initiate WebSocket connection: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to connect to notification service.');
      }
    }
  }

  // --- START: Changes related to _isMessageArrived ---
  void _handleWebSocketMessage(dynamic message) {
    debugPrint('Raw WebSocket message received: $message');
    try {
      final Map<String, dynamic> messageMap;
      if (message is String) {
        messageMap = jsonDecode(message) as Map<String, dynamic>;
      } else if (message is Map) {
        messageMap = message.cast<String, dynamic>();
      } else {
        debugPrint('Unknown WebSocket message type: ${message.runtimeType}');
        return;
      }
      debugPrint(messageMap.toString()); // Changed from print to debugPrint

      final content = messageMap['content']?.toString();

      if (content == null || content.isEmpty) {
        debugPrint('WebSocket message content is null or empty.');
        return;
      }

      debugPrint(
        'Parsed WebSocket message content: $content. Setting _isMessageArrived to true.',
      );

      // Update the state variables
      setState(() {
        _dialogContent = content; // Store the message content
        _isMessageArrived = true; // Set the flag to true
      });

      // Schedule the dialog to be shown after the current frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only show the dialog if the widget is still mounted and the flag is true
        if (_isMessageArrived && _dialogContent != null && mounted) {
          _showEmergencyRequestDialog(context, _dialogContent!);
        }
      });
    } catch (e, s) {
      debugPrint('Error handling WebSocket message: $e\nStack: $s');
    }
  }

  // Function to display the emergency request accepted dialog
  void _showEmergencyRequestDialog(BuildContext ctx, String content) {
    showDialog<void>(
          context: ctx, // Use the current context of this StatefulWidget
          barrierDismissible:
              false, // User must interact with buttons to dismiss
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Request Accepted'),
              content: Text(
                'Your emergency request has been accepted by the hospital. Map link: $content',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss the dialog
                  },
                ),
                TextButton(
                  child: const Text('Open Map'),
                  onPressed: () async {
                    Navigator.of(dialogContext).pop(); // Dismiss dialog first
                    _launchMapUrl(
                      content,
                      ctx,
                    ); // Use the context of the HospitalScreen
                  },
                ),
              ],
            );
          },
        )
        .then((_) {
          // This .then() block executes when the dialog is dismissed (popped)
          debugPrint(
            'HospitalScreen: Emergency dialog dismissed. Resetting _isMessageArrived.',
          );
          // Reset the state variables to hide the dialog for future rebuilds
          setState(() {
            _isMessageArrived = false; // Set the flag back to false
            _dialogContent = null; // Clear the dialog content
          });
        })
        .catchError((error) {
          debugPrint('HospitalScreen: Error showing/managing dialog: $error');
          // Ensure state is reset even if an error occurs
          setState(() {
            _isMessageArrived = false;
            _dialogContent = null;
          });
        });
  }
  // --- END: Changes related to _isMessageArrived ---

  Future<void> _launchMapUrl(
    String urlString,
    BuildContext fallbackContext,
  ) async {
    final Uri? uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint("Could not launch $uri: $e");
        _showErrorSnackBar("Could not open map.", context: fallbackContext);
      }
    } else {
      debugPrint('Could not launch $urlString (invalid or unlaunchable URI)');
      _showErrorSnackBar(
        'Invalid map link provided.',
        context: fallbackContext,
      );
    }
  }

  Future<void> _sendEmergencyAlertToHospital(Hospital hospital) async {
    _showSnackBar('Sending SOS to ${hospital.name}...', durationSeconds: 2);
    try {
      final position = await _getCurrentLocationWithPermissions();
      if (position == null) {
        _showErrorSnackBar(
          _errorMessage.isNotEmpty
              ? _errorMessage
              : 'Could not get current location for SOS.',
        );
        return;
      }

      // Ensure this creates a valid Google Maps URL
      // It should be `maps.google.com/maps?q=` followed by coordinates for proper linking
      final String locationLink =
          'https://maps.google.com/maps?q=${position.latitude},${position.longitude}';
      debugPrint('Emergency location link: $locationLink');

      await _hospitalService.sendEmergencyAlert(
        senderId: widget.userId,
        hospitalId: hospital.userId, // Assuming Hospital model has userId
        content: locationLink,
      );
      if (mounted) {
        _showSnackBar('Emergency alert sent to ${hospital.name}!');
      }
    } catch (e) {
      debugPrint('Failed to send emergency alert: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to send emergency alert: ${e.toString()}');
      }
    }
  }

  void _showSnackBar(
    String message, {
    int durationSeconds = 4,
    BuildContext? context,
  }) {
    // Prefer the widget's context, fallback to global if necessary for snacbars
    final effectiveContext = context ?? (mounted ? this.context : null);
    if (effectiveContext != null) {
      ScaffoldMessenger.of(effectiveContext).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: durationSeconds),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      debugPrint('Warning: Could not show snackbar. No valid context found.');
    }
  }

  void _showErrorSnackBar(String message, {BuildContext? context}) {
    // Prefer the widget's context, fallback to global if necessary for snacbars
    final effectiveContext = context ?? (mounted ? this.context : null);
    if (effectiveContext != null) {
      ScaffoldMessenger.of(effectiveContext).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      debugPrint(
        'Warning: Could not show error snackbar. No valid context found.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty && _hospitals.isEmpty) {
      return _buildErrorWidget(_errorMessage, onRetry: _fetchHospitalsData);
    }
    if (_hospitals.isEmpty) {
      return _buildErrorWidget(
        'No hospitals available near your location.',
        onRetry: _fetchHospitalsData,
        isError: false,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchHospitalsData,
      child: ListView.builder(
        itemCount: _hospitals.length,
        itemBuilder: (context, index) {
          final hospital = _hospitals[index];
          return HospitalCard(
            hospital: hospital,
            onEmergencyAlert: () => _sendEmergencyAlertToHospital(hospital),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(
    String message, {
    required VoidCallback onRetry,
    bool isError = true,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              size: 60,
              color: isError ? Colors.red : Colors.blueGrey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}

// Assuming HospitalCard and Hospital model are defined correctly elsewhere
// Pasting HospitalCard and a basic Hospital model here for completeness if you don't have them
/*
// This was included in the previous response's HomeScreen.dart, adjust as needed
// Assumed structure of Hospital model, adjust to your actual data structure
class Hospital {
  final String id;
  final String userId; // Assuming this is the ID used for WebSocket communication
  final String name;
  final String phoneNumber;
  final String email;
  final double latitude;
  final double longitude;

  Hospital({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.latitude,
    required this.longitude,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      userId: json['userId'], // Adjust according to your actual JSON key
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
*/

class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final VoidCallback onEmergencyAlert;

  const HospitalCard({
    super.key,
    required this.hospital,
    required this.onEmergencyAlert,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  radius: 30,
                  child: Icon(
                    Icons.local_hospital,
                    size: 30,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hospital.name,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      _buildContactRow(
                        context,
                        icon: Icons.phone,
                        text: hospital.phoneNumber,
                        iconColor: Colors.green,
                      ),
                      const SizedBox(height: 2),
                      _buildContactRow(
                        context,
                        icon: Icons.email,
                        text: hospital.email,
                        iconColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.emergency_outlined),
                label: const Text("SOS"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: onEmergencyAlert,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    Color? iconColor,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor ?? textTheme.bodySmall?.color?.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
