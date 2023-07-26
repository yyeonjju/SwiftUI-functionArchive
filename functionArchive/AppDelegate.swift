import Foundation
import UIKit
import SwiftUI
import SendBirdCalls
import CallKit
import PushKit
//import FirebaseCore
//import Firebase
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
    
    var queue: DispatchQueue = DispatchQueue(label: "com.sendbird.calls.quickstart.yeonju.appdelegate")
    var voipRegistry: PKPushRegistry?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        remoteNotificationsRegistration(application)
//        FirebaseApp.configure()
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
            // If success is true, the permission is given and notifications will be delivered.
            //        let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            //        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            //        UIApplication.shared.registerForRemoteNotifications()
        }
        
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
    }
}

/*
//파이어베이스에서 오는 알림 테스트하기 위해
//import Firebase 해야함
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("❤️❤️ Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}
*/


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
