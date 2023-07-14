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





class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var queue: DispatchQueue = DispatchQueue(label: "com.sendbird.calls.quickstart.yeonju.appdelegate")
    var voipRegistry: PKPushRegistry?
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        remoteNotificationsRegistration(application)
//        return true
//    }
    
//    func remoteNotificationsRegistration(_ application: UIApplication) {
//        application.registerForRemoteNotifications()
//
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//            guard error == nil else {
//                print("Error while requesting permission for notifications.")
//                return
//            }
//
//            // If success is true, the permission is given and notifications will be delivered.
//        }
//    }
    
    
    // 앱이 실행 중 일때 처리하는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        remoteNotificationsRegistration(application)
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func remoteNotificationsRegistration(_ application: UIApplication) {
        //https://developer.apple.com/documentation/uikit/uiapplication/1623078-registerforremotenotifications
        // Apple 푸시 알림 서비스에 등록하는 프로세스
        //이 등록이 성공하면 application(_:didRegisterForRemoteNotificationsWithDeviceToken:)
        //등록에 실패하면 앱은 application(_:didFailToRegisterForRemoteNotificationsWithError:) 호출
        //func unregisterForRemoteNotifications() => 등록된 원격 알람 취소
        // var isRegisteredForRemoteNotifications: Bool => 현재 원격알람이 등록되어 있는지 확인
//        application.registerForRemoteNotifications()
        
        //앱의 원격 알림이 알람, 뱃지, 사운드 등의 작업을 수행하도록 하려면 requestAuthorization 활용하여 권한을 요청해야한다
        //알림 설정 센터에서 알림에 관한 권한 요청을 보낸다
        //UNUserNotificationCenter.current()로 객체를 반환받은 뒤 requestAuthorization 메서드를 활용
        //completionHandler에서는 사용자가 권한을 허락했는지에 대한 여부와 에러에 대한 정보에 대해 상황을 처리
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            guard error == nil else {
                print("🌸Error while requesting permission for notifications.")
                return
            }
            print("🌸Success while requesting permission for notifications.")
            
            // If success is true, the permission is given and notifications will be delivered.
        }
        
        //        let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
        //        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        //        UIApplication.shared.registerForRemoteNotifications()
        
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
