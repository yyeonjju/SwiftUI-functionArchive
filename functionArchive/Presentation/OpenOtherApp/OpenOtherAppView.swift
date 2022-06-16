//
//  OpenOtherAppView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/15.
//

import SwiftUI

struct OpenOtherAppView: View {
    @Environment(\.openURL) private var openURL
    
    var attributedString: AttributedString {
      var attributedText = AttributedString("Go to  zoom app")
      attributedText.link = URL(string: "https://us05web.zoom.us/j/82250097095?pwd=dk56Qy9wcisrU2l1cWJEbGxFK1YyUT09")
      return attributedText
    }
    
    let zoomURL = URL(string: "https://us05web.zoom.us/j/82250097095?pwd=dk56Qy9wcisrU2l1cWJEbGxFK1YyUT09")!

    var body: some View {
        //⭐️openURL 사파리로 url 이동하여 앱 오픈
                Button {
                    if let url = URL(string: "https://us05web.zoom.us/j/82250097095?pwd=dk56Qy9wcisrU2l1cWJEbGxFK1YyUT09") {
                        openURL(url){ accepted in
                            print(accepted ? "Success" : "Failure")
                        }
                    }
                } label: {
                    Label("Get Help", systemImage: "person.fill.questionmark")
                }
        
        //⭐️UIApplication.shared.open 사파리로 url 이동하여 앱 오픈
        //        Button {
        //            if UIApplication.shared.canOpenURL(zoomURL) {
        //                UIApplication.shared.open(zoomURL, options: [:]) { success in
        //                print(success)
        //                }
        //            }
        //        } label: {
        //            Label("zoom", systemImage: "person.fill.questionmark")
        //        }
        
        //⭐️ 스타일링 한정적?? 노노
        //    Link("Go to  zoom app", destination: URL(string: "https://us05web.zoom.us/j/82250097095?pwd=dk56Qy9wcisrU2l1cWJEbGxFK1YyUT09")!)
        
        //⭐️ 이렇게 링크 라벨을 따로 줄 수 있다
        //        Link(destination: URL(string: "https://us05web.zoom.us/j/82250097095?pwd=dk56Qy9wcisrU2l1cWJEbGxFK1YyUT09")!) {
        //            HStack {
        //                Text("줌---")
        //                Image(systemName: "tortoise.fill")
        //                    .font(.largeTitle)
        //            } .foregroundColor(.black)
        //        }
        
        //⭐️ 텍스트에 직접 속성 삽입(AttributedString)
        //        Text(attributedString)
    }
    
}

//⭐️????
//struct OpenOtherAppView: View {
////    @Environment(\.openURL) private var openURL
//
//    var body: some View {
//        Text("Visit [Example Company](https://www.example.com) for details.")
//            .environment(\.openURL, OpenURLAction { url in
////                handleURL(url) // Define this method to take appropriate action.
//                print("----------")
//                return .handled
//            })
//    }
//}




struct OpenOtherAppView_Previews: PreviewProvider {
    static var previews: some View {
        OpenOtherAppView()
    }
}
