//
//  HeadlessWebviewManager.swift
//  headless_webview
//
//  Created by 王超 on 2022/1/29.
//

import Foundation
class HeadlessWebviewManager: NSObject {
    static var webViews: [Int: HeadlessWebview] = [:]
    
    public static func run(id: Int, url: String, channel: FlutterMethodChannel) -> Int {
       
        let headlessWebview = HeadlessWebview(channel: channel, id: id)
        webViews[id] = headlessWebview
        headlessWebview.load(url: url)
        return id
      
    }
}
