//
//  ViewBuilderPracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2023/06/02.
//

import SwiftUI

struct MyStruct1 {
    func contextMenu<MenuItems: View>(
        @ViewBuilder menuItems: () -> MenuItems
    ) -> some View {
        
        VStack{
            Text("@ViewBuilder로 받은 뷰 보여주기")
                .foregroundColor(.red)
                
            menuItems()
        }
        
    }
}

//struct ViewBuilderPracticeView: View {
//    let myStruct1 : MyStruct1 = MyStruct1()
//
//    var body: some View {
//        myStruct1.contextMenu {
//            Text("Cut")
//            Text("Copy")
//            Text("Paste")
//        }
//
//
//
//    }
//}

struct ViewBuilderPracticeView: View {
    @State var isShown : Bool = false
    
    var body: some View {
        
        ZStack{
            
            Button{
                self.isShown = true
            } label : {
                Text("탈퇴하시겠습니까?")
                    .asGreenToggleButton(isGreen : true)
                    .frame(width : 200)
                    .padding()
            }
            
            if isShown {
                CustomModal(
                    showingModal : $isShown,
                    header : {
                        Text("정말 탈퇴하시겠습니까?")
                    },
                    content : {
                        Text("지금 탈퇴하시면 사용했던 기록들이 삭제됩니다 그래도 탈퇴를 진행하시겠습니까?")
                    },
                    footer : {
                        HStack{

                            Button{
                                print("취소버튼")
                                self.isShown = false
                            } label : {
                                Text("취소")
                                    .asGreenToggleButton(isGreen : true)
                            }

                            Button{
                                print("확인버튼")
                                self.isShown = false
                            } label : {
                                Text("확인")
                                    .asGreenToggleButton(isGreen : false)
                            }
                        }

                    }

                )
            }
        }
        
    }
}

//클로저로 받는 뷰들을 제네릭으로 정의해준다

struct CustomModal<H, C, F>: View where H: View, C : View, F: View {
    @Binding var showingModal: Bool
    var header : () -> H
    var content : () -> C
    var footer : () -> F
    
    //초기화 코드에서 @ViewBuilder 키워드를 사용하여 구조체 초기화 시 클로저로 뷰를 받을 수 있도록한다
    //@escaping 키워드가 사용된 이유는 뷰 초기화 중에 바로 사용되지 않는다는 의미이다
    init(
        showingModal : Binding<Bool>,
        @ViewBuilder header : @escaping () -> H,
        @ViewBuilder content : @escaping () -> C,
        @ViewBuilder footer : @escaping () -> F
    ) {
        self._showingModal = showingModal
        self.header = header
        self.content = content
        self.footer = footer
    }
    
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button{
                    showingModal = false
                }label:{
                    Text("x")
                        .foregroundColor(.black)
                }
                
            }
            header()
                .padding(.vertical)
            
            content()
                .padding(.bottom)
            
            footer()
                .padding(.bottom)
        }
        .padding()
        .background(Color.gray)
        .frame(width: UIScreen.main.bounds.width*0.8)
        .cornerRadius(12)
    }
}
