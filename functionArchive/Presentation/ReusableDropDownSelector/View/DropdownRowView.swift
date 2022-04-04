//
//  DropdownRowView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/03.
//

import Foundation
import SwiftUI

struct DropdownRow: View {
    var option: DropdownOption //요소 하나의 타입
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        Button(action: {
            //⭐️ 매개변수로 전달된 onOptionSelected 로직이 있으면 실행!!
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                Text(self.option.value)
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}
