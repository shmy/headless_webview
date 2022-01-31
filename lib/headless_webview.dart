import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HeadlessResponse {
  final int id;
  final Uri url;
  final String? mimeType;

  HeadlessResponse(this.id, this.url, this.mimeType);

  factory HeadlessResponse.fromJson(Map<String, dynamic> json) =>
      HeadlessResponse(json['id'], Uri.parse(json['url']), json['mimeType']);

  @override
  String toString() {
    print('HeadlessResponse(id: $id, url: $url, mimeType: $mimeType)');
    return super.toString();
  }
}

class HeadlessWebview {
  static final MethodChannel _channel =
      const MethodChannel('tech.shmy.headless_webview')
        ..setMethodCallHandler(_onMethodCall);
  static final List<ValueChanged<HeadlessResponse>> _handlers = [];

  static Future<dynamic> _onMethodCall(MethodCall call) async {
    if (call.method == 'intercepted') {
      for (var handle in _handlers) {
        handle(HeadlessResponse.fromJson({
          "id": call.arguments['id'],
          "url": call.arguments['url'],
          "mimeType": call.arguments['mimeType'],
        }));
      }
    }
    return null;
  }

  static run({
    required String url,
    ValueChanged<HeadlessResponse>? onIntercepted,
  }) async {
    final id = await _channel.invokeMethod('launch', url);
    _handlers.add((HeadlessResponse response) {
      if (response.id != id) {
        return;
      }
      onIntercepted?.call(response);
    });
    return () async {
      await _channel.invokeMethod('close', id);
    };
  }
}
