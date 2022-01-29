#import "HeadlessWebviewPlugin.h"
#if __has_include(<headless_webview/headless_webview-Swift.h>)
#import <headless_webview/headless_webview-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "headless_webview-Swift.h"
#endif

@implementation HeadlessWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHeadlessWebviewPlugin registerWithRegistrar:registrar];
}
@end
