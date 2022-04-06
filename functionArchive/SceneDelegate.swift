import Foundation
import UIKit
import SwiftUI

//NSObject 타입으로 객체를 만들고 , UIWindowSceneDelegate프로토콜을 채택
//MySceneDelegate 는 App에다가 직접 연결하는 것이 아닌 MyAppDelegate 로 연결
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        //⭐️ scene이 앱에 추가될 때 호출
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        
            print("----scene")
//        guard let _ = (scene as? UIWindowScene) else { return }
            
        // 여기서 ContentView()를 호출하면서, 영구저장소를 environment로 등록시켜준다.
        //contentView = ContentView()로 지정되어 있기 때문에 어떠한 Swift파일을 만들어도 ContentView를 엑세스 할 수 있는것
        let contentView = ContentView()
            
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                
                //✅ EnvironmentObject 생성해주기 위해
                //✅ userSetting을 contentView에 전달해줌
                let userSetting = UserSetting()
                //✅ rootView: contentView 바로 뒤에 EnvironmentObject를 반드시 추가해줘야한다
                //✅✅✅ 이제 @ObservedObject가 아닌 @EnvironmentObject로 어느 뷰에서나 userSetting에 접근할 수 있다!!!✅✅✅
                window.rootViewController = UIHostingController(rootView: contentView.environmentObject(userSetting))
                
                
//                window.rootViewController  = UIHostingController(rootView: contentView)
                self.window = window
                window.makeKeyAndVisible()
            }
            


    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // scene이 연결이 해제될 때 호출 (다시 연결될 수 있음!)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // scene과의 상호작용이 시작될 때 호출
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // scene과의 상호작용이 중지될 때 호출 (e.g. 다른 화면으로의 전환)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // scene이 foreground로 진입할 때 호출
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // scene이 background로 진입할 때 호출
    }
}
