import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as ph;

void main() {
  runApp(const RescueGuideApp());
}

class RescueGuideApp extends StatelessWidget {
  const RescueGuideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RescueGuide App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const RealTimeLocationPage(),
    );
  }
}

class RealTimeLocationPage extends StatefulWidget {
  const RealTimeLocationPage({Key? key}) : super(key: key);

  @override
  State<RealTimeLocationPage> createState() => _RealTimeLocationPageState();
}

class _RealTimeLocationPageState extends State<RealTimeLocationPage> {
  late GoogleMapController _mapController;
  bool _isSharing = false;

  loc.LocationData? _currentLocation;  // Make _currentLocation nullable
  final loc.Location _location = loc.Location();

  final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Default position

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Request location permissions and get the current location
  Future<void> _getCurrentLocation() async {
    // Request permission using permission_handler
    ph.PermissionStatus permission = await ph.Permission.location.request();

    if (permission.isGranted) {
      loc.LocationData location = await _location.getLocation();
      setState(() {
        _currentLocation = location;  // Assign the location to _currentLocation
      });
    } else {
      print("Location permission denied");
    }
  }

  void _toggleSharing() {
    setState(() {
      _isSharing = !_isSharing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Sharing'),
        elevation: 0, // Removes the shadow under the AppBar
        backgroundColor: Colors.transparent, // Makes the background transparent
      ),
      body: Column(
        children: [
          // Google Map View
          Expanded(
            child: _currentLocation == null
                ? const Center(child: CircularProgressIndicator())  // Show a loading spinner while fetching location
                : GoogleMap(
                    onMapCreated: (controller) => _mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentLocation!.latitude!, 
                        _currentLocation!.longitude!
                      ),  // Use the non-nullable _currentLocation
                      zoom: 14.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: LatLng(
                          _currentLocation!.latitude!, 
                          _currentLocation!.longitude!
                        ),
                        infoWindow: const InfoWindow(
                          title: 'You are here',
                        ),
                      ),
                    },
                  ),
          ),
          // Start/Stop Sharing Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSharing ? Colors.red : Colors.green,
              ),
              onPressed: _toggleSharing,
              child: Text(
                _isSharing ? 'Stop Sharing Location' : 'Start Sharing Location',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          // Status Text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _isSharing
                  ? 'Real-time Status: Sharing with Emergency Services'
                  : 'Real-time Status: Not Sharing',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          // Button to navigate to Nearby Services
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NearbyServicesPage(),
                  ),
                );
              },
              child: const Text('Nearby Emergency Services'),
            ),
          ),
          // Add the new four buttons with icons
          _buildFourButtonsWithIcons(context),
        ],
      ),
    );
  }

  // New method to build four buttons with icons
  Widget _buildFourButtonsWithIcons(BuildContext context) {
    return Column(
      children: [
        _buildButtonWithIconAndEmoji(context, Icons.home, 'Home', () {
          // Navigate to Home Screen
        }),
        _buildButtonWithIconAndEmoji(context, Icons.sos, 'SOS', () {
          // Navigate to SOS screen
        }),
        _buildButtonWithIconAndEmoji(context, Icons.local_hospital, 'Emergency Services', () {
          // Navigate to Emergency Services screen
        }),
        _buildButtonWithIconAndEmoji(context, Icons.phone, 'Contact', () {
          // Navigate to Contact screen
        }),
      ],
    );
  }

  // Helper method to build individual buttons with icons
  Widget _buildButtonWithIconAndEmoji(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.orange), // Icon with size and color
            SizedBox(width: 10), // Spacing between icon and text
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class NearbyServicesPage extends StatefulWidget {
  const NearbyServicesPage({Key? key}) : super(key: key);

  @override
  State<NearbyServicesPage> createState() => _NearbyServicesPageState();
}

class _NearbyServicesPageState extends State<NearbyServicesPage> {
  final List<Map<String, String>> _services = const [
    {'name': 'Hospital A', 'phone': '+1 234 567 890', 'distance': '0.5 miles', 'lat': '37.7749', 'lng': '-122.4194'},
    {'name': 'Clinic B', 'phone': '+1 987 654 321', 'distance': '1 mile', 'lat': '37.7750', 'lng': '-122.4183'},
  ];

  late GoogleMapController _mapController;
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = Set<Marker>();
    _services.forEach((service) {
      _markers.add(
        Marker(
          markerId: MarkerId(service['name']!),
          position: LatLng(double.parse(service['lat']!), double.parse(service['lng']!)),
          infoWindow: InfoWindow(title: service['name']),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Emergency Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(_services),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Google Map
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194), // You can change this to the user's location
                zoom: 14.0,
              ),
              markers: _markers,
            ),
          ),
          // List of Services
          Expanded(
            child: ListView.builder(
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.local_hospital, color: Colors.red),
                        title: Text(service['name']!),
                        subtitle: Text('${service['distance']} away'),
                      ),
                      // Buttons below each service
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Call functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Call'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // More Info functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('More Info'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Get Directions functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('Get Directions'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate {
  final List<Map<String, String>> _services;

  DataSearch(this._services);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _services
        .where((service) =>
            service['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final service = results[index];
        return ListTile(
          title: Text(service['name']!),
          subtitle: Text('${service['distance']} away'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _services
        .where((service) =>
            service['name']!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final service = suggestions[index];
        return ListTile(
          title: Text(service['name']!),
          subtitle: Text('${service['distance']} away'),
        );
      },
    );
  }
}
