//
//  HeadlessWebviewManager.swift
//  headless_webview
//
//  Created by 王超 on 2022/1/29.
//

import Foundation
class HeadlessWebviewManager: NSObject {
    static private var id: Int = -2022;
    static var webViews: [Int: HeadlessWebview] = [:]
    
    public static func run(url: String, channel: FlutterMethodChannel) -> Int {
        HeadlessWebviewManager.id = HeadlessWebviewManager.id + 1
        if (HeadlessWebviewManager.id > 2022) {
            HeadlessWebviewManager.id = -2022;
        }
        let id = HeadlessWebviewManager.id
        let headlessWebview = HeadlessWebview(channel: channel, id: id)
        webViews[id] = headlessWebview
        headlessWebview.load(url: url)
        return id
      
    }
}
