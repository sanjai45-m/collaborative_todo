import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';

class DeviceService {
  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  String _deviceId = '';
  String _deviceName = '';

  Future<String> getDeviceId() async {
    if (_deviceId.isNotEmpty) return _deviceId;

    try {
      if (kIsWeb) {
        _deviceId = await _getWebDeviceId();
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        _deviceId = androidInfo.id;
        _deviceName = '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        _deviceId = iosInfo.identifierForVendor ?? iosInfo.utsname.machine;
        _deviceName = iosInfo.name ?? iosInfo.model;
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await _deviceInfo.windowsInfo;
        _deviceId = windowsInfo.computerName;
        _deviceName = windowsInfo.computerName;
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await _deviceInfo.macOsInfo;
        _deviceId = macInfo.computerName;
        _deviceName = macInfo.computerName;
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await _deviceInfo.linuxInfo;
        _deviceId = linuxInfo.machineId ?? linuxInfo.name;
        _deviceName = linuxInfo.name;
      }

      if (_deviceId.isEmpty) {
        _deviceId = await _generateFallbackId();
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _deviceId = '${_deviceId}_${packageInfo.packageName}';

      return _deviceId;
    } catch (e) {
      print('Error getting device ID: $e');
      return await _generateFallbackId();
    }
  }

  Future<String> _getWebDeviceId() async {
    try {
      return 'web_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      return 'web_fallback_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<String> _generateFallbackId() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String fallback = 'device_${packageInfo.packageName}_${packageInfo.buildNumber}';
    return fallback;
  }

  Future<String> getDeviceName() async {
    if (_deviceName.isNotEmpty) return _deviceName;

    try {
      if (kIsWeb) {
        _deviceName = 'Web Browser';
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        _deviceName = '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        _deviceName = iosInfo.name ?? 'iPhone';
      } else if (Platform.isWindows) {
        _deviceName = 'Windows PC';
      } else if (Platform.isMacOS) {
        _deviceName = 'Mac';
      } else if (Platform.isLinux) {
        _deviceName = 'Linux';
      }

      return _deviceName;
    } catch (e) {
      return 'Unknown Device';
    }
  }

  Future<String> getUserDisplayName() async {
    String deviceName = await getDeviceName();
    String deviceId = await getDeviceId();
    return '$deviceName (${deviceId.substring(0, 8)}...)';
  }
}
