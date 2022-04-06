//
//  ScoreView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/06.
//

import Foundation
import SwiftUI

class UserSetting: ObservableObject{
    @Published var score: Int = 0
}
 
struct ScoreView: View {
    
    //@ObservedObject
//    @ObservedObject var userSetting = UserSetting()
    
    //✅ UserSetting의 'Score'을 공통 위치에 두어 둘다 엑세스 할 수 있게하려면??
    //✅ @EnvironmentObject 사용할 수 있도록 SceneDelegate에 추가해줌
    @EnvironmentObject var userSetting : UserSetting
    
    var body: some View {
        VStack {
            Text("\(self.userSetting.score)")
                .font(.largeTitle)
            Button("클릭시 score 상승") {
                self.userSetting.score += 1
            }
            //구분선 추가
            Divider()
                .padding()
            
            //바인딩해서 가져오기때문에 $표시
            //@ObservedObject
//            MyScoreView(score: self.$userSetting.score)
            
            //✅ @EnvironmentObject
            //MyScoreView 뷰에서도 userSetting 인스턴스 접근 가능하므로 넘겨주지 않아도 된다
            MyScoreView()
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
//        ScoreView()
        
        //✅ userSetting을 SceneDelegate에 추가한 후
        ScoreView().environmentObject(UserSetting())
    }
}

