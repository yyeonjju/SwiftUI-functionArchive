//
//  functionArchiveApp.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/01.
//

import SwiftUI
import SendBirdCalls
import Foundation

@main
struct functionArchiveApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    @StateObject private var appState = SwiftUIAppState()
//    @StateObject var notificationCenter = NotificationCenter()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
//                .environmentObject(notificationCenter)
        }
    }
    
    init() {
        print( "🌸🌸🌸🌸🌸🌸SendBirdCall.configure")
        let appId: String = SendbirdIds.application_id
        SendBirdCall.configure(appId: appId)
    }
}

public extension UserDefaults {
    var remotePushToken: Data? {
        get { UserDefaults.standard.value(forKey: "com.sendbird.examples.pushtoken") as? Data }
        set { UserDefaults.standard.set(newValue, forKey: "com.sendbird.examples.pushtoken") }
    }
    
    var voipPushToken: Data? {
        get { UserDefaults.standard.value(forKey: "com.sendbird.examples.voippushtoken") as? Data }
        set { UserDefaults.standard.set(newValue, forKey: "com.sendbird.examples.voippushtoken") }
    }
}
