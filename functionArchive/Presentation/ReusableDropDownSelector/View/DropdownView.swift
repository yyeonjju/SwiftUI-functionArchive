//
//  DropdownView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/03.
//

import Foundation
import SwiftUI

struct Dropdown: View {
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    //⭐️ DropdownSelectorView에서 전달받은 매개변수 option와 onOptionSelected를 그대로 RowView에 전달한다.
                    DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                }
            }
        }
//        .zIndex(100)
        .frame(minHeight: CGFloat(options.count) * 30, maxHeight: 250) //⭐️ height 을 고정값으로 놓지 않고 유동적이게 수정
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}
