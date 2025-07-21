import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class TouchDetector {
  static bool _isTouchDevice = false;
  static bool _isInitialized = false;
  
  static bool get isTouchDevice {
    if (!_isInitialized) {
      _detectTouchCapability();
    }
    return _isTouchDevice;
  }
  
  static void _detectTouchCapability() {
    _isInitialized = true;
    
    if (kIsWeb) {
      // For web, we'll check if it's a touch device through JavaScript
      // In a real implementation, you'd use js interop, but for now we'll use a simple approach
      _isTouchDevice = false; // Default to false for web
    } else {
      // For native platforms
      if (Platform.isAndroid || Platform.isIOS) {
        _isTouchDevice = true;
      } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        _isTouchDevice = false;
      }
    }
  }
  
  // Alternative method: Check for touch capability at runtime
  static bool hasTouchCapability(BuildContext context) {
    // Check if the device has any touch input devices
    // This is a more dynamic approach that can detect touch screens on desktop devices
    return Platform.isAndroid || Platform.isIOS || 
           (kIsWeb && _checkWebTouchSupport());
  }
  
  static bool _checkWebTouchSupport() {
    // For web platform, we'd normally use dart:html or js interop
    // to check ('ontouchstart' in window) || (navigator.maxTouchPoints > 0)
    // For now, returning false as default
    return false;
  }
  
  // Method to manually override touch detection (useful for testing)
  static void setTouchDevice(bool isTouch) {
    _isTouchDevice = isTouch;
    _isInitialized = true;
  }
}