//
//  PushNotificationPracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2023/07/11.
//

import SwiftUI

struct PushNotificationPracticeView: View {
    //view struct에 함수
    //로컬 노티에 필요한 것
        func sendNoti() {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removeAllPendingNotificationRequests()
            
            let content = UNMutableNotificationContent()
            content.title = "로컬 알림 테스트 제목!! "
            content.subtitle = "서브타이틀"
            content.body = "로컬 알림 테스트입니다 ^^"
            
            //트리거는 알림이 발동되는 조건입니다. 크게 시간 간격(time interval), 특정한 시간(calendar), 위치(location)을 기준으로 알림을 발동시킬 수 있다
            //주의 ! : repeats 이 true이면 timeInterval은 적어도 60초 이상이 되어야한다
            //https://developer.apple.com/documentation/usernotifications/unpushnotificationtrigger
            //class UNCalendarNotificationTrigger / class UNTimeIntervalNotificationTrigger / class UNLocationNotificationTrigger / class UNNotificationTrigger
    //        let trigger = UNCalendarNotificationTrigger(
    //            dateMatching: Calendar.current.dateComponents([.hour, .minute], from: timePicker.date), repeats: true)
            // Fire in 30 minutes (60 seconds times 30)
    //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (30*60), repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            
            notificationCenter.getNotificationSettings { settings in
                
                //permission 상태는 5가지가 존재
                switch settings.authorizationStatus {
                case .authorized :
                    print(".authorized 앱이 권한을 요청했고 사용자가 허용한 경우 / rawValue 2")
                case .denied :
                    print(".denied 앱이 권한을 요청했으나 사용자가 거부한경우, 푸시 알림 거부상태인경우 / rawValue 0")
                case .notDetermined :
                    print(".notDetermined 앱이 권한 요청을 하지 않은 경우 / rawValue 1")
                case .provisional :
                    print(".provisional 앱이 권한을 요청했고, 사용자가 임시로 허용한 경우 / rawValue3")
                case .ephemeral :
                    print(".ephemeral 푸시 설정이 App Clip에 대해서만 부분적으로 동의한 경우 / rawValue 4")
                    
                default :
                    print("---")
                }
                
                
                switch settings.alertSetting {
                case .disabled :
                    print(".disabled 알림을 지원하지만 사용자가 알림을 끈경우 / rawValue 1")
                case .enabled :
                    print(".enabled 알림을 지원하고, 사용자가 알림을 허용한 경우 / rawValue 2")
                case .notSupported :
                    print(".notSupported 알림을 지원하지 않는 경우, 애초에 알림 권한 요청을 하지 않는경우 / rawValue 3")
                default :
                    print("---")
                }
   
            }
            
            //request는 UNNotificationRequest라는 클래스를 사용
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        // handle errors
                    }
                    print("🌸🌸🌸🌸🌸🌸 로컬 푸쉬알림 성공!!!!")
                }
        }
    
    var body: some View {
        VStack{
            Button{
                self.sendNoti()
            }label: {
                  Text("로컬 알림 와랏!!")
            }
            .asGreenToggleButton(isGreen: true)
        }
    }
}

struct PushNotificationPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PushNotificationPracticeView()
    }
}



