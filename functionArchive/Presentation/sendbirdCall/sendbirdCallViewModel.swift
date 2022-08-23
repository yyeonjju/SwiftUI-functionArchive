//
//  sendbirdCallViewModel.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/20.
//

import Foundation
import SendBirdCalls
import CallKit
import PushKit

//struct UserRole {
//    static let userType = "mentor"
//}
//
//struct SendbirdIds {
//    static let application_id : String =  "79DF9ADB-2954-4681-B2F0-B4C05F20E93A"
//    static let my_sendbird_id : String = "bf4ea5ba-1e02-11ed-8b95-0e259142797c"
//    static let partner_sendbird_id : String = "983dff6e-1e95-11ed-8b95-0e259142797c"
//}
//
//
////struct UserRole {
////    static let userType = "mentee"
////}
////struct SendbirdIds {
////    static let application_id : String =  "79DF9ADB-2954-4681-B2F0-B4C05F20E93A"
////    static let my_sendbird_id : String = "983dff6e-1e95-11ed-8b95-0e259142797c"
////    static let partner_sendbird_id : String = "bf4ea5ba-1e02-11ed-8b95-0e259142797c"
////}
//
//
//class sendbirdCallViewModel : ObservableObject {
//
//    @Published var currentCall: DirectCall?
//
//    func sendbirdInitAuthDial(){
//        //🌸🌸init🌸🌸
////        SendBirdCall.configure(appId: SendbirdIds.application_id)
//
//        // The USER_ID below should be unique to your Sendbird application.
//        let params = AuthenticateParams(userId: SendbirdIds.my_sendbird_id, accessToken: SendbirdIds.my_sendbird_id)
//        //🌸🌸auth🌸🌸
//        SendBirdCall.authenticate(with: params) { (user, error) in
//            guard let user = user, error == nil else {
//                print("error", error)
//                // Handle error.
//                return
//            }
//
//            print("🌸authenticated successfully & is connected to Sendbird server")
//            print(user)
//
//            //🌸🌸멘토는 dial🌸🌸
//            if(UserRole.userType == "mentor"){
//                let params = DialParams(calleeId: SendbirdIds.partner_sendbird_id, callOptions: CallOptions())
//                let directCall = SendBirdCall.dial(with: params) { directCall, error in
//                    guard let directCall = directCall, error == nil else {
//                        print("error", error)
//                        // Handle error.
//                        return
//                    }
//                    print("🌸The call has been created successfully")
//                    // The call has been created successfully
////                    CallManager(currentCall: directCall)
//                    self.currentCall = directCall
//                    print("🌸🌸🌸directCall")
//                    print(directCall)
//                }
//            }
//            //🌸🌸멘티는 accept🌸🌸
//            if(UserRole.userType == "mentee"){
//
////                let params = DialParams(calleeId: SendbirdIds.partner_sendbird_id, callOptions: CallOptions())
////                let directCall = SendBirdCall.dial(with: params) { directCall, error in
////                    guard let directCall = directCall, error == nil else {
////                        print("error", error)
////                        // Handle error.
////                        return
////                    }
////                    print("🌸The call has been created successfully")
////                    // The call has been created successfully
//////                    CallManager(currentCall: directCall)
////                    self.currentCall = directCall
////                    print("🌸🌸🌸directCall")
////                    print(directCall)
////                }
//            }
//
//
////            directCall.delegate = self //🌸🌸🌸🌸🌸🌸🌸????
//
//            // The user has been authenticated successfully and is connected to Sendbird server.
//
//            //🌸SendBirdCall.registerVoIPPush 푸쉬 할 때 필요한 것 ?! (앱을 업데이트(새로운 정보가 있을 때)하기 위해 푸시 알람을 앱에 보내는 것.)
//            // Register device token by using the `SendBirdCall.registerVoIPPush` or `SendBirdCall.registerRemotePush` methods.
//            //...
//        }
//    }
//}
//
////https://jaesung0o0.medium.com/sendbird-calls-%EB%B9%84%EB%94%94%EC%98%A4-%EB%A0%8C%EB%8D%94%EB%A7%81-%EB%B7%B0%EB%A5%BC-swiftui%EB%A1%9C-%EB%8B%A4%EB%A3%A8%EA%B8%B0-81eded4531b3
//
////class CallManager: ObservableObject {
////
////    @Published var currentCall: DirectCall?
////
////    init(currentCall : DirectCall? = nil) {
////        self.currentCall = currentCall
////    }
////    //...
////}



struct UserRole {
    static let userType = "mentor"
}

struct SendbirdIds {
    static let application_id : String =  "79DF9ADB-2954-4681-B2F0-B4C05F20E93A"
    static let my_sendbird_id : String = "bf4ea5ba-1e02-11ed-8b95-0e259142797c"
    static let partner_sendbird_id : String = "983dff6e-1e95-11ed-8b95-0e259142797c"
    static let mentoring_id : String = "000"
}

enum CallState: String {
    case none = ""
    case onDialing = "dialing"
    case onRinging = "ringing"
    case onEstablished = "established"
    case onConnected = "connected"
    case onReconnecting = "reconnecting"
    case onReconnected = "reconnected"
}

//struct UserRole {
//    static let userType = "mentee"
//}
//struct SendbirdIds {
//    static let application_id : String =  "79DF9ADB-2954-4681-B2F0-B4C05F20E93A"
//    static let my_sendbird_id : String = "983dff6e-1e95-11ed-8b95-0e259142797c"
//    static let partner_sendbird_id : String = "bf4ea5ba-1e02-11ed-8b95-0e259142797c"
//}


class SendbirdCallViewModel : ObservableObject {
    
    @Published var currentCall: DirectCall?
    @Published var callState: CallState = .none
    
    func dial() {
        /// 1. create `CallOptions` object
        let callOptions = CallOptions(
            isAudioEnabled: true,
            isVideoEnabled: true,
            localVideoView: nil,
            remoteVideoView: nil,
            useFrontCamera: true
        )
        
        /// 2. create `DialParams` object.
        let dialParams = DialParams(
            calleeId: SendbirdIds.partner_sendbird_id,
            isVideoCall: true,
            callOptions: callOptions,
            customItems: ["mentoring_call_id":SendbirdIds.mentoring_id]
        )
        /// 3. dial with `DialParams`
        SendBirdCall.dial(with: dialParams) { [self] (call, error) in
            /// 4. error handling
            guard let call = call else {
                print(error?.localizedDescription ?? "unknown error")
                return
            }
            /// 5. set `DirectCallDelegate`
            call.delegate = self
            /// 6. set `self.call`
            self.currentCall = call
            /// 7. update call state
            callState = .onDialing
        }
    }
    
//    func accept() {
//        /// 1. create `CallOptions` object
//        let callOptions = CallOptions(
//            isAudioEnabled: true,
//            isVideoEnabled: false,
//            localVideoView: nil,
//            remoteVideoView: nil,
//            useFrontCamera: true
//        )
//        /// 2. create `AcceptParams` with call options
//        let acceptParams = AcceptParams(callOptions: callOptions)
//
//        /// 3. accept incoming call with accept params
//        currentCall?.accept(with: acceptParams)
//    }
//
    func end() {
        /// 1. end call
        currentCall?.end()
    }
    
//    func sendbirdInitAuthDial(){
        //🌸🌸init🌸🌸
//        SendBirdCall.configure(appId: SendbirdIds.application_id)

        // The USER_ID below should be unique to your Sendbird application.
//        let params = AuthenticateParams(userId: SendbirdIds.my_sendbird_id, accessToken: SendbirdIds.my_sendbird_id)
//        //🌸🌸auth🌸🌸
//        SendBirdCall.authenticate(with: params) { (user, error) in
//            guard let user = user, error == nil else {
//                print("error", error)
//                // Handle error.
//                return
//            }
//
//            print("🌸authenticated successfully & is connected to Sendbird server")
//            print(user)
//            //🌸🌸멘토는 dial🌸🌸
//            if(UserRole.userType == "mentor"){
//                self.dial()
//            }
//        }
//    }
}




/// To update call state
extension SendbirdCallViewModel: DirectCallDelegate {
    func didEstablish(_ call: DirectCall) {
        callState = .onEstablished
    }
    func didConnect(_ call: DirectCall) {
        callState = .onConnected
    }
    
    func didStartReconnecting(_ call: DirectCall) {
        callState = .onReconnecting
    }
    
    func didReconnect(_ call: DirectCall) {
        callState = .onReconnected
    }
    
    func didEnd(_ call: DirectCall) {
        callState = .none
        /// set `self.call` as nil
        self.currentCall = nil
    }
}

