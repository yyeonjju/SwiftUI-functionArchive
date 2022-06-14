//
//  ModalPracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/12.
//

import SwiftUI


struct ModalPracticeView: View {
    
    @State private var textEntered = ""
    @State private var showingModal = false
    
//    init() {
//        UITextView.appearance().backgroundColor = .green
//    }
    
    var body: some View {
        ZStack {
            

            
            VStack(spacing: 20) {
                Text("-----")
                
                Button("Show Alert") {
                    self.showingModal.toggle()
                    self.textEntered = ""
                }
                Text("\(textEntered)")
                
                Spacer()
            }
            // ⭐️⭐️ body가 일반 텍스트인 모달
//            if(showingModal){
//                Color.red.opacity(0.3)
//                    .edgesIgnoringSafeArea(.all)
//            .onTapGesture{
//                showingModal = false
//            }
//
//                CustomNormalModal(
//                    showingModal: $showingModal,
//                    header : {
//                        Text("정말 수업을 취소하시겠어요?")
//                            .font(.system(size:20, weight: .bold))
//                    },
//                    content : {
//                        VStack{
//                            Text("수업시작 24시간 이전")
//                            Text("취소 및 변경 가능 (크레딧 환급)")
//                            Text("수업시작 24시간 이내")
//                            Text("취소 및 변경 불가 (크레딧 차감)")
//                        }
//                        .foregroundColor(.gray)
//                    },
//                    footer : {
//                        Button{
//                            print("로직")
//                            showingModal = false
//                        } label : {
//                            Text("확인")
//                        }
//                    }
//
//                )
//            }
            
            // ⭐️⭐️ body에 TextEditor가 들어가있는 모달
            if(showingModal){
                Color.red.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
//                    .onTapGesture{
//                        showingModal = false
//                    }
                
                CustomNormalModal(
                    showingModal: $showingModal,
                    header : {
                        Text("취소 사유를 적어주세요")
                            .font(.system(size:20, weight: .bold))
                            .onTapGesture{
                                print(textEntered)
                            }
                    },
                    content : {
                        TextEditor(text: $textEntered)
//                        TextField("Enter text", text: $textEntered)
                            .padding()
//                            .textInputAutocapitalization(.never)
//                            .disableAutocorrection(true)
                            .foregroundColor(.black)
                            .frame(height: 200)
                            .colorMultiply(Color(UIColor.systemGray5))
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(12)
                    },
                    footer : {
                        Button{
                            print("로직")
                            showingModal = false
                        } label : {
                            Text("확인")
                        }
                    }
                    
                )
            }
            
        }
    }
}

struct ModalPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        ModalPracticeView()
    }
}

struct CustomNormalModal<H, C, F>: View where H: View, C : View, F: View {
    @Binding var showingModal: Bool
    var header : () -> H
    var content : () -> C
    var footer : () -> F
    
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
                        .foregroundColor(.gray)
                }

            }
            header()
                .padding(.vertical)
            
            content()
                .padding(.vertical)

            footer()
                .padding(.vertical)
        }
        .padding()
        .background(Color.white)
        .frame(width: UIScreen.main.bounds.width*0.8)
        .cornerRadius(12)
////        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.white)
//                .frame(maxWidth: 300, maxHeight: 500)
//                .overlay{
//                    VStack {
//                        HStack{
//                            Spacer()
//                            Button{
//                                showingModal = false
//                            }label:{
//                                Text("x")
//                                    .foregroundColor(.gray)
//                            }
//
//                        }
//                        header()
//                            .padding(.vertical)
//
//                        content()
//                            .padding(.vertical)
//
//                        footer()
//                            .padding(.vertical)
//                    }
//                    .padding()
//                }
////        }
    }
}


