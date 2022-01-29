import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_webview/headless_webview.dart';

void main() {
  const MethodChannel channel = MethodChannel('headless_webview');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await HeadlessWebview.platformVersion, '42');
  // });
}
