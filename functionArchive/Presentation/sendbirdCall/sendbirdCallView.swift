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
    @StateObject var vm  : sendbirdCallViewModel = sendbirdCallViewModel()
//    @StateObject var callManager: CallManager = CallManager()
    @SwiftUI.State private var isPresented : Bool = false
    
    var body: some View {
        VStack{
            Button{
                vm.sendbirdInitAuthDial()
                self.isPresented = true
//                func checkCameraPermission(){
//                   AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
//                       if granted {
//                           print("Camera: 권한 허용")
//
//                       } else {
//                           print("Camera: 권한 거부")
//                       }
//                   })
//                }
               
            }label : {
                Text("멘토링 참가하기")
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
        .fullScreenCover(isPresented: self.$isPresented){
            ZStack{
                Color.gray
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
//                    Text("fullScreenCover")
                    HStack{
                        Button{
                            self.isPresented = false
                        } label : {
                            Text("닫기")
                        }
                        
                        Button{
                            vm.currentCall?.stopVideo()
                        } label : {
                            Text("화면 안보이게")
                        }
                        
                        Button{
                            print(vm.currentCall?.isLocalVideoEnabled)
                        } label : {
                            Text("지금 화면 상태는???")
                        }
                        
                    }

                    
                    VStack{
//                        Text("local video")
//                            .frame( maxWidth: .infinity, maxHeight: .infinity)
//                            .background(Color.blue)
                        VideoView(call: vm.currentCall, type: .local)
                            .ignoresSafeArea()
                       
                    }
                    .overlay(alignment : .topLeading){
//                        Text("remote video")
//                        .frame(width: 120, height: 190)
//                        .background(Color.brown)
//                        .padding(15)
                        
                        VideoView(call: vm.currentCall, type: .remote)
                               .frame(width: 120, height: 190)
                               .padding(15)

                        
                          
                    }
                    
                    
                    
                        
                }
            }

        }
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
