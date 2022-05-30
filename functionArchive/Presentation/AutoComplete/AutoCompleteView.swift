//
//  AutoCompleteView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/05/25.
//

import Foundation
import SwiftUI

//struct DropdownOption: Hashable {
//    let value: String
//    let label : String
//}

class AutoCompleteViewModel : ObservableObject {
    @Published var companyName = ""
//    {
//        didSet (value) {
//            fetch()
//            print(companyName)
//
//        }
//    }
    func fetch () {
        print("하하하핳")
    }
}

struct AutoCompleteView : View {
    @StateObject var vm : AutoCompleteViewModel = AutoCompleteViewModel()
    @State private var text = ""
    @State private var options = [
        DropdownOption(value: "1", label: "1"),
        DropdownOption(value: "2", label: "2"),
        DropdownOption(value: "3", label: "3"),
        DropdownOption(value: "4", label: "4"),
        DropdownOption(value: "5", label: "5")
]
    @State private var selectedOption : DropdownOption?
//    @State private var textField = ""
    private let buttonHeight: CGFloat = 60
    
    
    var body : some View {
        VStack(alignment: .leading){
            
//            Text("text 확인")
//                .onTapGesture {
//                    print(vm.companyName)
//                    print(selectedOption)
//                }
            TextField(
                "학교를 검색하세요",
                text: Binding(
                    get: {
                        return selectedOption?.label ?? ""
                    },
                    set: {
                        vm.companyName = $0
                    }
                )
            )
                .padding()
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .foregroundColor(.black)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(12)
                .frame(height: 60)
                .overlay(
                    VStack {
//                        if self.shouldShowDropdown {
                            Spacer(minLength: buttonHeight+20)
                            DropdownView(options: self.options, onOptionSelected: { option in
//                                shouldShowDropdown = false
                                selectedOption = option
//                                self.onOptionSelected?(option)
                            })
//                        }
                    }, alignment: .topLeading
                )
                .background(
                    RoundedRectangle(cornerRadius: 5).fill(Color.white)
                )
                .zIndex(10)
            
        }
        .padding(20)
//        .onReceive(vm.$companyName, perform: { name in
//            print(name)
//            vm.fetch()
//
//        })
        
        
    }
}

struct DropdownView: View {

    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    //DropdownSelectorView에서 전달받은 매개변수 option와 onOptionSelected를 그대로 RowView에 전달한다.
                    DropdownRowView(option: option, onOptionSelected: self.onOptionSelected)
                }
            }
        }
        .frame(minHeight: CGFloat(options.count) * 30, maxHeight: 250) // height 을 고정값으로 놓지 않고 유동적이게
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct DropdownRowView: View {

    var option: DropdownOption
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        Button(action: {
            //매개변수로 전달된 onOptionSelected 로직이 있으면 실행!!
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
                print(self.option)
            }
        }) {
            HStack {
                Text(self.option.label)
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}
