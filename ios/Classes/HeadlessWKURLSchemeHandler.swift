//
//  HeadlessWKURLSchemeHandler.swift
//  headless_webview
//
//  Created by 王超 on 2022/1/28.
//

import Foundation
import WebKit

class HeadlessWKURLSchemeHandler: NSObject, WKURLSchemeHandler {
    public let channel: FlutterMethodChannel
    public let id: Int
    public var methodName = "intercepted"
    private var tasks: [URLSessionTask] = []
    private var holdUrlSchemeTasks: [String: Bool] = [:]
    init(channel: FlutterMethodChannel, id: Int) {
        self.channel = channel
        self.id = id
    }
    deinit {
        print("HeadlessWKURLSchemeHandler deinit")
    }
    public func cancelAll() {
        tasks.forEach { task in
            // https://juejin.cn/post/6844903954212454413
            if let isValid = self.holdUrlSchemeTasks[task.description] {
                if !isValid {
                    return
                }
                if (task.state == .running) {
                    task.cancel()
                }
            }
           
        }
        tasks.removeAll()
    }
    
    @available(iOS 11.0, *)
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        holdUrlSchemeTasks[urlSchemeTask.description] = false
    }
    @available(iOS 11.0, *)

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
      
       guard let url = urlSchemeTask.request.url else {
           return
       }
       holdUrlSchemeTasks[urlSchemeTask.description] = true
       let task = URLSession.shared.dataTask(with: urlSchemeTask.request) { (data, response, error) in
           var arguments = [String: Any]()
           arguments["id"] = self.id
           arguments["url"] = url.absoluteString
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
           
        }
        task.resume()
        tasks.append(task)
    
   }
}
