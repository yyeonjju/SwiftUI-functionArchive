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



