//
//  MyScoreView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/06.
//

import Foundation
import SwiftUI
 
struct MyScoreView: View {
    
    //UserSetting의 score을 바인딩해서 가져옴
//    @Binding var score: Int
    
    //✅ @EnvironmentObject 사용할 수 있도록 SceneDelegate에 추가해줌
    @EnvironmentObject var userSetting : UserSetting
    
    var body: some View {
        VStack {
            Text("\(self.userSetting.score)")
            Button("클릭시 score 증가") {
                self.userSetting.score += 1
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.black)
            
        }
        .padding()
        .background(Color.yellow)
        
        
        
    }
}
 
struct MyScoreView_Previews: PreviewProvider {
    static var previews: some View {
        //바인딩해온 값을 .constant값으로 설정
//        MyScoreView(score: .constant(0))
        
        //✅ userSetting을 SceneDelegate에 추가한 후
        MyScoreView().environmentObject(UserSetting())
    }
}
