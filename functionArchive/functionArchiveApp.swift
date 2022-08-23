//
//  functionArchiveApp.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/01.
//

import SwiftUI
import SendBirdCalls

@main
struct functionArchiveApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    @StateObject private var appState = SwiftUIAppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
    
    init() {
        print( "🌸🌸🌸🌸🌸🌸SendBirdCall.configure")
        let appId: String = SendbirdIds.application_id
        SendBirdCall.configure(appId: appId)
    }
}
