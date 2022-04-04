//
//  DropdownSelectorView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/03.
//

import Foundation
import SwiftUI



struct DropdownSelectorView: View {
    @State private var shouldShowDropdown = false //드롭다운 여부
    @State private var selectedOption: DropdownOption? = nil //선택된 옵션
    var placeholder: String //플레이스홀더
    var options: [DropdownOption] //옵션들
    var onOptionSelected: ((_ option: DropdownOption) -> Void)? //옵션 선택됐을 떄 실행되는 이벤트 함수
    private let buttonHeight: CGFloat = 45
    private let buttonWidth : CGFloat = 200
    
    
    var body: some View {
        Button(action: {
            self.shouldShowDropdown.toggle() //⭐️ 버튼 누르면 드롭다운 여부 토글
        }) {
            HStack {
                //⭐️ 선택된 옵션이 없으면 플레이스홀더 선택한 값이 있으면 그 옵션 인스턴스의 value 값으로 세팅
                Text(selectedOption == nil ? placeholder : selectedOption!.value)
                    .font(.system(size: 14))
                    .foregroundColor(selectedOption == nil ? Color.gray: Color.black)
                Spacer()
                //⭐️ 드롭다운 여부에 따라 화살표 모양 변경
                Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 5)
                    .font(Font.system(size: 9, weight: .medium))
                    .foregroundColor(Color.black)
            }
        }
        .padding(.horizontal)
        .cornerRadius(5)
        .frame(width: self.buttonWidth, height: self.buttonHeight)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
        .overlay(
            VStack {
                if self.shouldShowDropdown {
                    Spacer(minLength: buttonHeight + 10)
                    Dropdown(options: self.options, onOptionSelected: { option in
                        //⭐️ Dropdown에 넘겨주는 onOptionSelected는  DropdownㄱRow 요소 중 하나 클릭했을 때
                        // ⭐️1) dropdown 다시 사라지게
                        shouldShowDropdown = false
                        // ⭐️2) 클릭한 요소가 selectedOption 값이 될 수 있도록
                        selectedOption = option
                        // ⭐️3) DropdownSelectorView에서 매개변수로 받은 onOptionSelected로직 실행
                        self.onOptionSelected?(option)
                    })
                }
            }, alignment: .topLeading
        )
        .background(
            RoundedRectangle(cornerRadius: 5).fill(Color.white)
        )
    }
}

struct DropdownSelectorView_Previews: PreviewProvider {
    static var uniqueKey: String {
            UUID().uuidString
        }

        static let options: [DropdownOption] = [
            DropdownOption(key: uniqueKey, value: "Sunday"),
            DropdownOption(key: uniqueKey, value: "Monday"),
            DropdownOption(key: uniqueKey, value: "Tuesday"),
            DropdownOption(key: uniqueKey, value: "Wednesday"),
            DropdownOption(key: uniqueKey, value: "Thursday"),
            DropdownOption(key: uniqueKey, value: "Friday"),
            DropdownOption(key: uniqueKey, value: "Saturday")
        ]


        static var previews: some View {
            Group {
                DropdownSelectorView(
                    placeholder: "Day of the week",
                    options: options,
                    onOptionSelected: { option in
                        print(option)
                })
                .padding(.horizontal)
            }
        }
}
