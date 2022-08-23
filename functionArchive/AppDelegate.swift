import Foundation
import UIKit
import SwiftUI
import SendBirdCalls

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
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        UserDefaults.standard.remotePushToken = deviceToken
        SendBirdCall.registerRemotePush(token: deviceToken, completionHandler: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SendBirdCall.application(application, didReceiveRemoteNotification: userInfo)
    }
}
