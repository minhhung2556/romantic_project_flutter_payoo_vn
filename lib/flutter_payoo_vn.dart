library flutter_payoo_vn;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// This plugin helps in integrating the [Payoo](https://payoo.vn) native mobile SDK into Flutter application project.
/// Currently, Payoo supports only Android & iOS platforms.
class PayooVnPlugin {
  static const MethodChannel _channel = const MethodChannel('vn.payoo.plugin');

  /// Need to call this method before starting using Payoo's features.
  /// This method could be called at initialize state of application or a screen that uses Payoo's features.
  /// It's ok to be called multiple times.
  static Future<dynamic> initialize(PayooVnSettings settings) async {
    var settingsMap = settings.toMap();
    debugPrint('PayooVnPlugin.initialize: $settingsMap');
    return await _channel.invokeMethod('initialize', settingsMap);
  }

  /// Navigate to a Payoo's service screen.
  /// [serviceId] : is defined by Payoo. See [PayooVnServiceIds].
  static Future<dynamic> navigate(String serviceId) async {
    debugPrint('PayooVnPlugin.navigate: $serviceId');
    return await _channel
        .invokeMethod('navigate', <String, dynamic>{'serviceId': serviceId});
  }
}

/// The initializing settings to create a Payoo SDK instance.
/// Contacts to your partnership member who receives this information from Payoo, for both environments: Development & Production.
class PayooVnSettings {
  /// [merchantId] : Payoo specifics each of their partners if a merchant, with an id & [secretKey].
  final String? merchantId;

  /// [secretKey] : this is not a sensitive key, just a client public key.
  final String? secretKey;

  /// [isDev] : this is not used for Development environment, it's only a flag that make the SDK knows if application is in debugging/developing mode.
  final bool? isDev;

  /// Constructor.
  const PayooVnSettings({this.isDev: false, this.merchantId, this.secretKey});

  /// Convert to a map.
  Map<String, dynamic> toMap() {
    return {
      'merchantId': this.merchantId,
      'secretKey': this.secretKey,
      'isDev': this.isDev,
    };
  }

  /// Create an instance from a map.
  factory PayooVnSettings.fromMap(Map<String, dynamic> map) {
    return new PayooVnSettings(
      merchantId: map['merchantId'] as String?,
      secretKey: map['secretKey'] as String?,
      isDev: map['isDev'] as bool?,
    );
  }
}

/// Current supported services of Payoo SDK.
class PayooVnServiceIds {
  static const topup = 'topup';
  static const electric = "DIEN";
  static const water = "NUOC";
}
