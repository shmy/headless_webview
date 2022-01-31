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
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late final VoidCallback dispose;

    dispose = await HeadlessWebview.run(
        url:
            "https://jx.parwix.com:4433/player/?url=https://v.qq.com/x/cover/mzc00200nx1hbcr.html",
        onIntercepted: (res) {
          if (res.url.path.endsWith("mp4") || res.url.path.endsWith("m3u8")) {
            print(res);
          }
        });
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
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
