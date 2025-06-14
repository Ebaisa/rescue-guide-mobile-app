import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class HospitalFinderLauncher extends StatefulWidget {
  const HospitalFinderLauncher({Key? key}) : super(key: key);

  @override
  State<HospitalFinderLauncher> createState() => _HospitalFinderLauncherState();
}

class _HospitalFinderLauncherState extends State<HospitalFinderLauncher> {
  @override
  void initState() {
    super.initState();
    _launchNearbyHospitals();
  }

  Future<void> _launchNearbyHospitals() async {
    try {
      final permissionStatus = await Permission.location.request();

      if (!permissionStatus.isGranted) {
        throw 'Location permission denied';
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final url = Uri.parse(
        'https://www.google.com/maps/search/hospitals+nearby/@${position.latitude},${position.longitude},15z/data=!3m1!4b1?entry=ttu',
      );

      if (!await canLaunchUrl(url)) {
        throw 'Could not launch Google Maps';
      }

      await launchUrl(url, mode: LaunchMode.externalApplication);
      if (mounted) Navigator.pop(context); // Auto-pop screen after launching
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
