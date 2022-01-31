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
    private var headlessWKURLSchemeHandler: HeadlessWKURLSchemeHandler?
    private var uiWindow: UIWindow?
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
        
        self.uiWindow = UIApplication.shared.keyWindow
        self.uiWindow?.insertSubview(self.webView!, at: 0)
        self.uiWindow?.sendSubviewToBack(self.webView!)
        
    }
    deinit {
        print("HeadlessWebview - dealloc")
        self.uiWindow = nil
        self.webView = nil
        self.headlessWKURLSchemeHandler?.cancelAll()
        self.headlessWKURLSchemeHandler = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func load(url: String) {
        self.webView!.load(NSURLRequest(url: NSURL(string:url)! as URL) as URLRequest)
    }

}
