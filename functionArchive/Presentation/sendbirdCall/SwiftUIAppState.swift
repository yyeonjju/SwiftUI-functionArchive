//
//  SwiftUIAppState.swift
//  SwiftUIBasic
//
//  Created by Jaesung Lee on 2021/06/14.
//

import Combine
import SendBirdCalls

class SwiftUIAppState: ObservableObject, SendBirdCallDelegate {
    /// Notify ringing
    @Published var onRinging: Bool = false
    
    var incomingCall: DirectCall? {
        didSet {
            /// set delegate and update `onRinging` status
            incomingCall?.delegate = self
            onRinging = incomingCall != nil
        }
    }
    
    init() {
        /// set `SendBirdCallDelegate`
        SendBirdCall.addDelegate(self, identifier: "AppDelegate")
    }
    
    func didStartRinging(_ call: DirectCall) {
        print("🌸didStartRinging()")
        /// set incomingCall
        incomingCall = call
    }
    
    func reset() {
        print("🌸reset()")
        /// Reset incoming call
        incomingCall = nil
    }
}

/// To call reset
extension SwiftUIAppState: DirectCallDelegate {
    func didEstablish(_ call: DirectCall) {
        print("🌸didEstablish()")
        self.reset()
    }
    
    func didConnect(_ call: DirectCall) {
        print("🌸didConnect()")
        //
    }
    
    func didEnd(_ call: DirectCall) {
        print("🌸didEnd()")
        self.reset()
    }
}

