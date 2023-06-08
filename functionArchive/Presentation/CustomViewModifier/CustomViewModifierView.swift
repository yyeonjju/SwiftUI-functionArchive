//
//  CustomViewModifierView.swift
//  functionArchive
//
//  Created by 하연주 on 2023/05/31.
//

import SwiftUI

struct CustomViewModifierView: View {
    @State var isGreen : Bool = true
    
    var body: some View {
        VStack{
            Button {
                self.isGreen.toggle()
            } label: {
                Text("시작하기")
                    .asGreenToggleButton(isGreen : isGreen)
            }
            .padding(.horizontal)
        }
    }
}

struct CustomViewModifierView_Previews: PreviewProvider {
    static var previews: some View {
        CustomViewModifierView()
    }
}
