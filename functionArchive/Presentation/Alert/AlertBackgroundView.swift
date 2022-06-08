//
//  AlertBackgroundView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/07.
//

import SwiftUI

struct AlertBackgroundView: View {
    @State private var show = false
    
    var body: some View {
        Button{
            show = true
        } label : {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .background(Color.blue)
                .foregroundColor(.white)
        }
//        .alert(isPresented: $show, content: {
//            Alert(
//                title: Text("제목제목"),
//                message: Text("메시지메시지"),
//                primaryButton: .destructive(Text("확인")) { print("...") },
//                secondaryButton: .cancel()
//            )
//        })
        
        
//        .alert("Alert Title", isPresented: $show) {
////            Button("취소", role: .destructive) {}
//            Button("취소", role: .cancel) {}
//            Button("저장안함") {}
//            Button("저장") {}
//        } message: {
//            Text("This is alert dialog sample")
//        }
//
        
//        .actionSheet(isPresented: $show, content: {
//            ActionSheet(
//                title: Text("변경사항을 저장할까요?"),
////                message: Text("Message"),
//                buttons: [
//                    .default(Text("저장안함"), action : {
//                        print("저장안함")
//                    }),
//                    .default(Text("저장"), action : {
//                        print("저장")
//                    }),
////                    .destructive(Text("destructive"), action : {
////                        print("destructive")
////                        self.show = false
////                    }),
//                    .cancel({
//                        print("Cancel")
//                    })])
//        })
        
        
        .confirmationDialog(
            "변경사항을 저장할까요?",
            isPresented: $show,
            titleVisibility: .visible,
            actions: {
                Button("저장안함") { }
                Button("저장") { }
                Button("취소", role: .cancel) { }
            }
        )
        
        //CalendarOpenViewModel 에서 selectedDate가 있을 때!

    }
}

struct AlertBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        AlertBackgroundView()
    }
}
