import Flutter
import UIKit


public class SwiftHeadlessWebviewPlugin: NSObject, FlutterPlugin {
  public static  var channel: FlutterMethodChannel?;
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "tech.shmy.headless_webview", binaryMessenger: registrar.messenger())
    let instance = SwiftHeadlessWebviewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel!)
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if (call.method == "launch") {
          let id = HeadlessWebviewManager.run(url: call.arguments! as! String, channel: SwiftHeadlessWebviewPlugin.channel!)
          result(id)
      } else if (call.method == "close") {
          let id = call.arguments! as! Int
          HeadlessWebviewManager.webViews.removeValue(forKey: id)
          result(nil)
      } else if (call.method == "canUse") {
          if #available(iOS 11.0, *) {
              result(true)
          } else {
              result(false)
          }
          
      } else {
          result(FlutterMethodNotImplemented)
      }
     
  }
}
