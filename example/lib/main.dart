import 'package:flutter/material.dart';
import 'package:flutter_payoo_vn/flutter_payoo_vn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('This is Payoo'),
              ElevatedButton(
                  onPressed: () {
                    _navigate(PayooVnServiceIds.topup);
                  },
                  child: Text(PayooVnServiceIds.topup)),
              ElevatedButton(
                  onPressed: () {
                    _navigate(PayooVnServiceIds.electric);
                  },
                  child: Text(PayooVnServiceIds.electric)),
              ElevatedButton(
                  onPressed: () {
                    _navigate(PayooVnServiceIds.water);
                  },
                  child: Text(PayooVnServiceIds.water)),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _navigate(String serviceId) async {
    final res = await PayooVnPlugin.navigate(serviceId);
    print('_MyAppState._navigate: $res');
  }

  void _initialize() async {
    final res = await PayooVnPlugin.initialize(PayooVnSettings(
        isDev: true,
        merchantId: "your-merchant-id",
        secretKey: "your-merchant-secret-key"));
  }
}
