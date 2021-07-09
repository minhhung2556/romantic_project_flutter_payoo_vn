import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_payoo_vn/flutter_payoo_vn.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('vn.payoo.plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'initialize') {
        var settings = methodCall.arguments as Map<dynamic, dynamic>;
        var merchantId = settings['merchantId'] as String?;
        var secretKey = settings['secretKey'] as String?;
        // var isDev = settings['isDev'] as bool?;
        if (merchantId?.isNotEmpty == true && secretKey?.isNotEmpty == true) {
          return true;
        } else
          return false;
      } else if (methodCall.method == 'navigate') {
        var arguments = methodCall.arguments as Map<dynamic, dynamic>;
        var serviceId = arguments['serviceId'];
        if (serviceId == PayooVnServiceIds.topup ||
            serviceId == PayooVnServiceIds.water ||
            serviceId == PayooVnServiceIds.electric) {
          return jsonEncode(<dynamic, dynamic>{
            'paymentCode': 'htyk6554tgev34',
            'paymentFee': 15213.12,
            'totalAmount': 512314.53,
          });
        } else {
          return null;
        }
      }
      return null;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('initialize', () async {
    expect(
        await PayooVnPlugin.initialize(PayooVnSettings(
            isDev: true, merchantId: '2342143', secretKey: 'dfasfasfasdf')),
        true);

    expect(
        await PayooVnPlugin.initialize(
            PayooVnSettings(isDev: true, merchantId: '', secretKey: '')),
        false);
  });

  test('navigate', () async {
    var res = await PayooVnPlugin.navigate(PayooVnServiceIds.topup);
    var data = jsonDecode(res as String);
    expect(data is Map, true);

    res = await PayooVnPlugin.navigate(PayooVnServiceIds.water);
    data = jsonDecode(res as String);
    expect(data is Map, true);

    res = await PayooVnPlugin.navigate(PayooVnServiceIds.electric);
    data = jsonDecode(res as String);
    expect(data is Map, true);

    res = await PayooVnPlugin.navigate('adasds');
    expect(res == null, true);
  });
}
