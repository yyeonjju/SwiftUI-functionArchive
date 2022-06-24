//
//  WebViewPractice.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/23.
//

import SwiftUI
import UIKit
import WebKit

struct WebViewPractice: View {
    @State private var showLoginForm: Bool = true
    @State private var url = "https://www.google.com"

    var body: some View {
//        if showLoginForm {
//            Button(action: {
//                showLoginForm = false
//                url = "https://www.example.com/go/1"
//            }) { Text("Try!") }
//        } else {
//            WebView(url: url)
//        }
        
        
        NavigationLink{
            WebView(url: url)
        } label : {
            Text("Try!")
        }
    }
}

struct WebViewPractice_Previews: PreviewProvider {
    static var previews: some View {
        WebViewPractice()
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

struct WebView : UIViewRepresentable {
    var url: String

    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(url)
    }
}

