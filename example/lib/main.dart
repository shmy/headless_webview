import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:headless_webview/headless_webview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() {
    late final VoidCallback dispose;
    RegExp linkExp = RegExp(r'.*?byteamone.cn.*');
    RegExp featureExp = RegExp(r'.*?.flv');

    dispose = HeadlessWebview.run(
      url:
          "http://124.248.66.175:695/?url=https://www.bilibili.com/bangumi/play/ep471898",
      onIntercepted: (res) {
        final String url = res.url.toString();
        if (linkExp.hasMatch(url)) {
          print(featureExp.hasMatch(url));
        }
      },
      headless: false,
    );
    Timer(const Duration(seconds: 10), () {
      dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
      ),
    );
  }
}
