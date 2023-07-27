import Foundation
import UIKit
import SwiftUI
import SendBirdCalls
import CallKit
import PushKit
//import FirebaseCore
import Firebase
//import UserNotifications


/*
class NotificationCenter: NSObject, ObservableObject {
    @Published var responseData: UNNotificationResponse?
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationCenter: UNUserNotificationCenterDelegate  {
    // 앱이 foreground상태 일 때, 알림이 온 경우 어떻게 표현할 것인지 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }

    
    // push를 탭한 경우 처리 (local notification 이든, remote notification 이든 푸쉬 알림 온 것을 탭했을 때 )
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        responseData = response
        

        // deep link처리 시 아래 url값 가지고 처리
        let url = response.notification.request.content.userInfo
        print("🌸 알림 body ==> \(response.notification.request.content.body)")
        print("🌸 알림 왔을 때 그 push 를 탭한 경우 ==> url = \(url)")
        
        
        //https://fomaios.tistory.com/entry/iOS-%ED%91%B8%EC%89%AC-%EC%95%8C%EB%A6%BC-%ED%83%AD%ED%96%88%EC%9D%84-%EB%95%8C-%ED%8A%B9%EC%A0%95-%ED%8E%98%EC%9D%B4%EC%A7%80%EB%A1%9C-%EC%9D%B4%EB%8F%99%ED%95%98%EA%B8%B0
        let application = UIApplication.shared
        
        //앱이 켜져있는 상태에서 푸쉬 알림을 눌렀을 때
        if application.applicationState == .active {
            print("푸쉬알림 탭(앱 켜져있음)")
        }
        
        //앱이 꺼져있는 상태에서 푸쉬 알림을 눌렀을 때
        if application.applicationState == .inactive {
          print("푸쉬알림 탭(앱 꺼져있음)")
        }
        
        
//        NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["index":1])
        

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
}
 */





class AppDelegate: NSObject, UIApplicationDelegate {
    //🌈🌈 firebase cloud messaging🌈🌈
    let gcmMessageIDKey = "gcm.message_id"
    
    var queue: DispatchQueue = DispatchQueue(label: "com.sendbird.calls.quickstart.yeonju.appdelegate")
    var voipRegistry: PKPushRegistry?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //🌈🌈 firebase cloud messaging🌈🌈
        FirebaseApp.configure()
        //🌈🌈 firebase cloud messaging🌈🌈
        Messaging.messaging().delegate = self //extension AppDelegate: MessagingDelegate {} 생성해주어야함
        
        remoteNotificationsRegistration(application)
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func remoteNotificationsRegistration(_ application: UIApplication) {
        
        //사용자에게 알림 권한 요청
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in //options: [.alert, .badge, .sound, .provisional]
            guard error == nil else {
                print("🌸Error while requesting permission for notifications.")
                return
            }
            
            print("🌸Success while requesting permission for notifications.")
            DispatchQueue.main.async {
                //⭐️⭐️remote notificaiton⭐️⭐️ APNs에 디바이스 토큰 등록
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        //아래도 알림 권한 요청하는 코드인데 이건 iOS 10 미만에서만 이렇게 쓰였으므로 의미 없음
//        let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
//        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
//
    }
    
    //⭐️⭐️remote notificaiton⭐️⭐️ 디바이스토큰이 APNs에 등록실패했을 때
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🌸🌸🌸🌸🌸🌸RemoteNotification fail register")
        print(error.localizedDescription)
    }
    
    //⭐️⭐️remote notificaiton⭐️⭐️ 디바이스토큰이 APNs에 등록되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("🌸🌸🌸🌸🌸🌸RemoteNotification did register -- deviceToken")
        print(deviceToken)
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print(deviceTokenString)
//        UserDefaults.standard.remotePushToken = deviceToken
//        SendBirdCall.registerRemotePush(token: deviceToken, completionHandler: nil)
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("🌸🌸🌸🌸🌸🌸RemoteNotification did Receive Remote Notification")
        SendBirdCall.application(application, didReceiveRemoteNotification: userInfo)
        
        //🌈🌈 firebase cloud messaging🌈🌈
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        print("🌈🌈userInfo",userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
        
    }
}


//🌈🌈 firebase cloud messaging🌈🌈
//import Firebase 해야함
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("🌈🌈 Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate  {
    // 앱이 foreground상태 일 때, 알림이 온 경우 어떻게 표현할 것인지 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }

    
    // push를 탭한 경우 처리 (local notification 이든, remote notification 이든 푸쉬 알림 온 것을 탭했을 때 )
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        

        // deep link처리 시 아래 url값 가지고 처리
        let url = response.notification.request.content.userInfo
        print("🌸 알림 body ==> \(response.notification.request.content.body)")
        print("🌸 알림 왔을 때 그 push 를 탭한 경우 ==> url = \(url)")
        
        
        //https://fomaios.tistory.com/entry/iOS-%ED%91%B8%EC%89%AC-%EC%95%8C%EB%A6%BC-%ED%83%AD%ED%96%88%EC%9D%84-%EB%95%8C-%ED%8A%B9%EC%A0%95-%ED%8E%98%EC%9D%B4%EC%A7%80%EB%A1%9C-%EC%9D%B4%EB%8F%99%ED%95%98%EA%B8%B0
        let application = UIApplication.shared
        
        //앱이 켜져있는 상태에서 푸쉬 알림을 눌렀을 때
        if application.applicationState == .active {
            print("푸쉬알림 탭(앱 켜져있음)")
        }
        
        //앱이 꺼져있는 상태에서 푸쉬 알림을 눌렀을 때
        if application.applicationState == .inactive {
          print("푸쉬알림 탭(앱 꺼져있음)")
        }
        
        
//        NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["index":1])
        

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
}


/*
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
 */
