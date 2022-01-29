//
//  WKWebView+Custome.swift
//  headless_webview
//
//  Created by 王超 on 2022/1/28.
//

import Foundation
import WebKit
import ObjectiveC

class WKWebViewCustome: NSObject {
    static private var processed = false;
    static func hookWKWebView() {
        if (processed) {
            return
        }
            if #available(iOS 11.0, *) {
                guard let origin = class_getClassMethod(WKWebView.self, #selector(WKWebView.handlesURLScheme(_:))),
                      let hook = class_getClassMethod(WKWebView.self, #selector(WKWebView._handlesURLScheme(_:))) else {
                          return
                      }
                method_exchangeImplementations(origin, hook)
                processed = true
            } else {
                // Fallback on earlier versions
            }
            
    }

}

fileprivate extension WKWebView {
    @available(iOS 11.0, *)
    @objc static func _handlesURLScheme(_ urlScheme: String) -> Bool {
        if (urlScheme == "http" || urlScheme == "https") {
            return false
        } else {
            return WKWebView.handlesURLScheme(urlScheme)
        }
    }
}
