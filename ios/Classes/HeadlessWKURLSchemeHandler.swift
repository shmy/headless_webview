//
//  HeadlessWKURLSchemeHandler.swift
//  headless_webview
//
//  Created by 王超 on 2022/1/28.
//

import Foundation
import WebKit
import SwiftTryCatch

class HeadlessWKURLSchemeHandler: NSObject, WKURLSchemeHandler {
    public let channel: FlutterMethodChannel
    public let id: Int
    public var methodName = "intercepted"
    private var tasks: [URLSessionTask] = []
    init(channel: FlutterMethodChannel, id: Int) {
        self.channel = channel
        self.id = id
    }
    deinit {
        print("HeadlessWKURLSchemeHandler deinit")
    }
    public func cancelAll() {
        tasks.forEach { task in
            if (task.state == .running) {
                task.cancel()
            }
        }
        tasks.removeAll()
    }
    
    @available(iOS 11.0, *)
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}
    @available(iOS 11.0, *)

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
      
       guard let url = urlSchemeTask.request.url else {
           return
       }
       let task = URLSession.shared.dataTask(with: urlSchemeTask.request) { (data, response, error) in
           var arguments = [String: Any]()
           arguments["id"] = self.id
           arguments["url"] = url.absoluteString
           
           SwiftTryCatch.try({
                   if (error == nil) {
                       arguments["mimeType"] = response!.mimeType
                       self.channel.invokeMethod(self.methodName, arguments: arguments)
                       urlSchemeTask.didReceive(response!)
                       urlSchemeTask.didReceive(data!)
                       urlSchemeTask.didFinish()
                   } else {
                       self.channel.invokeMethod(self.methodName, arguments: arguments)
                       urlSchemeTask.didFailWithError(error!)
                   }
                }, catch: { (error) in
                    print("\(String(describing: error?.description))")
                }, finally: {
                    // close resources
           })
           
        }
        task.resume()
        tasks.append(task)
    
   }
}
