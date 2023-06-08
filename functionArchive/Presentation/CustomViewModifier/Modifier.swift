//
//  Modifier.swift
//  functionArchive
//
//  Created by 하연주 on 2023/05/31.
//

import Foundation
import SwiftUI


struct GreenToggleButton : ViewModifier {
    var isGreen : Bool //초록 버튼일 때 true, 회색 버튼일 때 false

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .font(.system(size: 16, weight : .bold))
            .foregroundColor( isGreen ? .white : .gray)
            .background( isGreen ? .green : Color(UIColor.systemGray5))
            .cornerRadius(12)
    }
}


extension View {
    
    func asGreenToggleButton(isGreen bool : Bool) -> some View {
        modifier(GreenToggleButton(isGreen : bool))
    }
    
}
