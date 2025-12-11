import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../constants/app_constants.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        final file = File(image.path);
        
        // Check file size
        final fileSize = await file.length();
        if (fileSize > AppConstants.maxImageSizeInBytes) {
          throw Exception(
            'Imagem muito grande. Tamanho máximo: ${AppConstants.maxImageSizeInBytes ~/ (1024 * 1024)}MB',
          );
        }
        
        return file;
      }
      
      return null;
    } catch (e) {
      throw Exception('Erro ao selecionar imagem: $e');
    }
  }

  // Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        final file = File(image.path);
        
        // Check file size
        final fileSize = await file.length();
        if (fileSize > AppConstants.maxImageSizeInBytes) {
          throw Exception(
            'Imagem muito grande. Tamanho máximo: ${AppConstants.maxImageSizeInBytes ~/ (1024 * 1024)}MB',
          );
        }
        
        return file;
      }
      
      return null;
    } catch (e) {
      throw Exception('Erro ao capturar imagem: $e');
    }
  }

  // Convert image file to base64
  static Future<String> fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      throw Exception('Erro ao converter imagem: $e');
    }
  }

  // Convert base64 to image bytes
  static List<int> base64ToBytes(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      throw Exception('Erro ao decodificar imagem: $e');
    }
  }

  // Show image picker dialog
  static Future<File?> showImageSourceDialog({
    required Function() onGallery,
    required Function() onCamera,
  }) async {
    // This should be called from a widget context
    // Implementation will be in the UI layer
    throw UnimplementedError('Use showImageSourceDialog from UI layer');
  }
}
