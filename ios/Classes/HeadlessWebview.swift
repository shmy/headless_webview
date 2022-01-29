//
//  HeadlessWebview.swift
//  headless_webview
//
//  Created by 王超 on 2022/1/28.
//

import Foundation
import WebKit


class HeadlessWebview: NSObject {
    private var webView: WKWebView?
    private var headlessWKURLSchemeHandler: HeadlessWKURLSchemeHandler
    init(channel: FlutterMethodChannel, id: Int) {
        WKWebViewCustome.hookWKWebView()
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        self.headlessWKURLSchemeHandler = HeadlessWKURLSchemeHandler(channel: channel, id: id)
        
        if #available(iOS 11.0, *) {
            configuration.setURLSchemeHandler(self.headlessWKURLSchemeHandler, forURLScheme: "http")
            configuration.setURLSchemeHandler(self.headlessWKURLSchemeHandler, forURLScheme: "https")
        }
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        
        if let keyWindow = UIApplication.shared.keyWindow {
                        /// Note: The WKWebView behaves very unreliable when rendering offscreen
                        /// on a device. This is especially true with JavaScript, which simply
                        /// won't be executed sometimes.
                        /// So, add the headless WKWebView to the view hierarchy.
                        /// This way is also possible to take screenshots.
            keyWindow.insertSubview(self.webView!, at: 0)
            keyWindow.sendSubviewToBack(self.webView!)
            }
    }
    deinit {
        print("HeadlessWebview - dealloc")
        self.webView = nil
        self.headlessWKURLSchemeHandler.cancelAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func load(url: String) {
        self.webView!.load(NSURLRequest(url: NSURL(string:url)! as URL) as URLRequest)
    }

}
