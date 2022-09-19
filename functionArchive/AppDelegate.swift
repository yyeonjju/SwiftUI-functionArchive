import Foundation
import UIKit
import SwiftUI
import SendBirdCalls
import CallKit
import PushKit

//NSObject 타입으로 객체를 만들고 , UIApplicationDelegate프로토콜을 채택
//class AppDelegate:  NSObject, UIApplicationDelegate {
//
//// UIApplicationDelegate가 제공하는 메서드 application()
//  func application(
//    _ application: UIApplication,
//    //⭐️ 앱이 처음 실행된 뒤 실행
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
//  ) -> Bool {
//      print("----")
//    // ...
//    return true
//  }
//
//// MySceneDelegate 는 App에다가 직접 연결하는 것이 아닌 MyAppDelegate에 연결
//  func application(
//    _ application: UIApplication,
//    //⭐️ Scene이 새로 생긴 뒤 실행
//    configurationForConnecting connectingSceneSession: UISceneSession,
//    options: UIScene.ConnectionOptions
//  ) -> UISceneConfiguration {
//      print("----")
//    let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
//    //sceneConfig.delegateClass를 MySceneDelegate로 설정해줌으로써 MySceneDelegate 도 활용할 수 있게됨
//    sceneConfig.delegateClass = SceneDelegate.self
//    return sceneConfig
//  }
//
//  func application(
//    _ application: UIApplication,
//    //⭐️ Scene이 삭제된 뒤 실행
//    didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//
//  }
//
//}





class AppDelegate: NSObject, UIApplicationDelegate {
    
    var queue: DispatchQueue = DispatchQueue(label: "com.sendbird.calls.quickstart.yeonju.appdelegate")
    var voipRegistry: PKPushRegistry?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        remoteNotificationsRegistration(application)
        return true
    }
    
    func remoteNotificationsRegistration(_ application: UIApplication) {
        application.registerForRemoteNotifications()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            guard error == nil else {
                print("Error while requesting permission for notifications.")
                return
            }
            
            // If success is true, the permission is given and notifications will be delivered.
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🌸🌸🌸🌸🌸🌸RemoteNotification fail register")
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("🌸🌸🌸🌸🌸🌸RemoteNotification did register -- deviceToken")
        print(deviceToken)
        UserDefaults.standard.remotePushToken = deviceToken
        SendBirdCall.registerRemotePush(token: deviceToken, completionHandler: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("🌸🌸🌸🌸🌸🌸RemoteNotification did Receive Remote Notification")
        SendBirdCall.application(application, didReceiveRemoteNotification: userInfo)
    }
}


extension AppDelegate: PKPushRegistryDelegate {
    

    
    func voipRegistration() {
        print("🌸🌸PKPushRegistryDelegate voipRegistration")
        self.voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        self.voipRegistry?.delegate = self
        self.voipRegistry?.desiredPushTypes = [.voIP]
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("🌸🌸PKPushRegistryDelegate pushRegistry -- didUpdate")
        UserDefaults.standard.voipPushToken = pushCredentials.token
        
        SendBirdCall.registerVoIPPush(token: pushCredentials.token, unique: true) { error in
            guard error == nil else { return }
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("🌸🌸PKPushRegistryDelegate pushRegistry -- didReceiveIncomingPushWith")
        SendBirdCall.pushRegistry(registry, didReceiveIncomingPushWith: payload, for: type, completionHandler: nil)
    }
    
    // Please refer to `AppDelegate+SendBirdCallsDelegates.swift` file.
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("🌸🌸PKPushRegistryDelegate pushRegistry -- didReceiveIncomingPushWith")
        SendBirdCall.pushRegistry(registry, didReceiveIncomingPushWith: payload, for: type) { uuid in
            guard uuid != nil else {
                let update = CXCallUpdate()
                update.remoteHandle = CXHandle(type: .generic, value: "invalid")
                let randomUUID = UUID()
                
                CXCallManager.shared.reportIncomingCall(with: randomUUID, update: update) { _ in
                    CXCallManager.shared.endCall(for: randomUUID, endedAt: Date(), reason: .acceptFailed)
                }
                completion()
                return
            }
            completion()
        }
    }
}
