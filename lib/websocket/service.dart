import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class HospitalService {
  WebSocketChannel? _channel;
  static const String _baseUrl = 'https://eba.onrender.com';

  Future<List<Hospital>> fetchNearestHospitals({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/get-nearest-hospital/').replace(
        queryParameters: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      debugPrint('Request URI: $uri');

      final response = await http
          .get(uri, headers: {'accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      debugPrint('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          // Assume it's a list of hospitals
          return decoded.map((e) => Hospital.fromJson(e)).toList();
        } else if (decoded is Map<String, dynamic>) {
          final hospitalsData =
              decoded['nearestHospital'] ??
              decoded['hospitals'] ??
              decoded['data'];
          if (hospitalsData is List) {
            return hospitalsData.map((e) => Hospital.fromJson(e)).toList();
          }
        }

        throw FormatException('Unexpected JSON structure in hospital response');
      } else if (response.statusCode == 422) {
        // Parse and throw validation error message
        final errorData = jsonDecode(response.body);
        final detail = errorData['detail']?[0];
        final msg = detail?['msg'] ?? 'Invalid location parameters';
        throw Exception('Validation error: $msg');
      } else {
        throw Exception(
          'API request failed with status ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      debugPrint('Fetch error: $e');
      throw Exception('Failed to fetch hospitals: $e');
    }
  }

  Future<void> connectWebSocket(String userId) async {
    try {
      print(userId);
      print("00000000000000000");
      if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }
      print("============");
      _channel = IOWebSocketChannel.connect(
        Uri.parse('wss://eba.onrender.com/ws/user/$userId'),
        pingInterval: const Duration(seconds: 30),
      );

      // Optional wait for connection (can be removed if not needed)
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print(e.toString());
      throw Exception('WebSocket connection failed: $e');
    }
  }

  Future<void> sendEmergencyAlert({
    required String senderId,
    required String hospitalId,
    required String content,
  }) async {
    if (_channel == null || _channel!.closeCode != null) {
      throw Exception('WebSocket not connected');
    }

    try {
      final message = {
        "sender_type": "user",
        "sender_id": senderId,
        "recipient_type": "hospital",
        "recipient_id": hospitalId,
        "content": content,
      };

      _channel!.sink.add(jsonEncode(message));
    } catch (e) {
      throw Exception('Failed to send alert: $e');
    }
  }

  Stream<dynamic> get notificationStream =>
      _channel?.stream ?? const Stream.empty();

  void dispose() {
    _channel?.sink.close();
    _channel = null;
  }
}

class Hospital {
  final String userId;
  final String name;
  final String phoneNumber;
  final String email;
  final double latitude;
  final double longitude;
  final double distance;
  final String location;

  Hospital({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.location,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    try {
      return Hospital(
        userId: json['userId'] as String,
        name: json['name'] as String,
        phoneNumber: json['phoneNumber'] as String,
        email: json['email'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        distance: (json['distance'] as num).toDouble(),
        location: json['location'] as String,
      );
    } catch (e) {
      throw FormatException('Invalid hospital JSON format: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'location': location,
    };
  }
}
