import Foundation
import UIKit
import SwiftUI

//NSObject 타입으로 객체를 만들고 , UIApplicationDelegate프로토콜을 채택
class AppDelegate:  NSObject, UIApplicationDelegate {

// UIApplicationDelegate가 제공하는 메서드 application()
  func application(
    _ application: UIApplication,
    //⭐️ 앱이 처음 실행된 뒤 실행
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
      print("----")
    // ...
    return true
  }

// MySceneDelegate 는 App에다가 직접 연결하는 것이 아닌 MyAppDelegate에 연결
  func application(
    _ application: UIApplication,
    //⭐️ Scene이 새로 생긴 뒤 실행
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
      print("----")
    let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    //sceneConfig.delegateClass를 MySceneDelegate로 설정해줌으로써 MySceneDelegate 도 활용할 수 있게됨
    sceneConfig.delegateClass = SceneDelegate.self
    return sceneConfig
  }

  func application(
    _ application: UIApplication,
    //⭐️ Scene이 삭제된 뒤 실행
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

  }

}
