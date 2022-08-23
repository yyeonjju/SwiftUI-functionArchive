//
//  sendbirdCallView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/20.
//

import SwiftUI
import SendBirdCalls
import AVFoundation

struct sendbirdCallView: View {
    @StateObject var vm  : SendbirdCallViewModel = SendbirdCallViewModel()
//    @StateObject var callManager: CallManager = CallManager()
    @SwiftUI.State private var isPresented : Bool = false
    @EnvironmentObject private var appState: SwiftUIAppState
    
    init(){
        let params = AuthenticateParams(userId: SendbirdIds.my_sendbird_id, accessToken: SendbirdIds.my_sendbird_id)
        
        SendBirdCall.authenticate(with: params) { (user, error) in
            guard let user = user, error == nil else {
                print("error", error)
                // Handle error.
                return
            }

            print("🌸authenticated successfully & is connected to Sendbird server")
            print(user)
        }
    }
    
    var body: some View {
        VStack{
            Text("멘토링 디테일 페이지")

            Button{
//                vm.sendbirdInitAuthDial()
                if(UserRole.userType == "mentor"){
                    vm.dial()
                }
                self.isPresented = true
               
            }label : {
                Text("멘토링 참가하기 버튼 ")
            }
        }
        .onChange(of: vm.currentCall){ call in
            if let call = call{
                print("🌸🌸🌸🌸call🌸🌸🌸🌸")
                print(call.callId)
                print(call.callee)
                print(call.localVideoView)
                print(call.isLocalVideoEnabled)
            }
            
        }
        .onChange(of: vm.callState){callState in
            print("🌸🌸🌸🌸callState🌸🌸🌸🌸")
            print(callState.rawValue)
            
        }
        .onChange(of: appState.onRinging){ ringing in
            print("🌸🌸🌸🌸onRinging🌸🌸🌸🌸")
            print(ringing)
        }
        .fullScreenCover(isPresented: self.$isPresented){
            ZStack{
                Color.gray
                    .edgesIgnoringSafeArea(.all)
                
                VStack{

//                    HStack{
                        Button{
                            self.isPresented = false
                        } label : {
                            Text("닫기")
                        }
//
//                        Button{
//                            vm.currentCall?.stopVideo()
//                        } label : {
//                            Text("화면 안보이게")
//                        }
//
//                        Button{
//                            print(vm.currentCall?.isLocalVideoEnabled)
//                        } label : {
//                            Text("지금 화면 상태는???")
//                        }
//
//                    }

                    
                    VStack{
                        VideoView(call: vm.currentCall, type: .remote)
                            .ignoresSafeArea()
                       
                    }
                    .overlay(alignment : .topLeading){
                        VideoView(call: vm.currentCall, type: .local)
                               .frame(width: 120, height: 190)
                               .padding(15)
                    
                    }
                    .overlay(alignment : .bottom){
                        if vm.callState != .none {
                            VStack{
                                Text(vm.currentCall?.callId ?? "Failed call")
                                
                                HStack{
                                    Text(vm.callState.rawValue)
                                    
                                    Button(action: vm.end) {
                                        endStyleBody
                                    }
                                }
                            }
                          
                        }
                      
                    }
       
                }
            }

        }
    }
    
    var endStyleBody: some View {
        Color
            .red
            .frame(width: 30, height: 30)
            .cornerRadius(26)
            .overlay(
                Image(systemName: "phone.down.fill")
                    .foregroundColor(.white)
            )
    }
}

//struct sendbirdCallView_Previews: PreviewProvider {
//    static var previews: some View {
//        sendbirdCallView()
//    }
//}


struct VideoView: UIViewRepresentable {
    enum VideoType {
        case local
        case remote
    }
    let call: DirectCall?
    let type: VideoType
    

    func makeUIView(context: Context) -> SendBirdVideoView {
        return SendBirdVideoView(frame: UIScreen.main.bounds)

    }
    func updateUIView(_ uiView: SendBirdVideoView, context: Context) {
        switch self.type {
        case .local:
            uiView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            call?.updateLocalVideoView(uiView)
        case .remote:
            call?.updateRemoteVideoView(uiView)
        }
    }
}


