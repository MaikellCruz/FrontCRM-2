import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  await _initializeServices();

  // Run the app
  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize Storage Service
    final storageService = StorageService();
    await storageService.init();

    // Initialize API Service
    final apiService = ApiService();
    await apiService.init();

    print('✅ Services initialized successfully');
  } catch (e) {
    print('❌ Error initializing services: $e');
  }
}
