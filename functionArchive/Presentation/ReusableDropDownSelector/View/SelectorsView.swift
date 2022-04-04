//
//  SelectorsView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/03.
//

import Foundation
import SwiftUI

struct SelectorsView: View {
//    static var uniqueKey: String {
//            UUID().uuidString
//        }
//
//        static let options: [DropdownOption] = [
//            DropdownOption(key: uniqueKey, value: "Sunday", label : "Sunday"),
//            DropdownOption(key: uniqueKey, value: "Monday", label:"Monday"),
//            DropdownOption(key: uniqueKey, value: "Tuesday", label:"Tuesday"),
//            DropdownOption(key: uniqueKey, value: "Wednesday", label: "Wednesday"),
//            DropdownOption(key: uniqueKey, value: "Thursday", label :"Thursday"),
//            DropdownOption(key: uniqueKey, value: "Friday", label:"Friday"),
//            DropdownOption(key: uniqueKey, value: "Saturday", label:"Saturday")
//        ]
    
    @ObservedObject var viewModel = InterviewFilterSelectorViewModel()
    
    var body: some View {
        ZStack{
            Color.blue
            
            VStack{
//                DropdownSelectorView(
//                    placeholder: "Day of the week",
//                    options: SelectorsView.options,
//                    onOptionSelected: { option in
//                        print(option)
//                })
//                DropdownSelectorView(
//                    placeholder: "Day of the week",
//                    options: SelectorsView.options,
//                    onOptionSelected: { option in
//                        print(option)
//                })
                HStack{
                    DropdownSelectorView(
                        shouldShowDropdown: $viewModel.shouldShowTypeDropdown,
                        selectedOption:$viewModel.typeSelectedOption,
                        placeholder: viewModel.employmentTypePlaceholder,
                        options: viewModel.employmentTypeOptions,
                        onOptionSelected: { option in
                            print(option)
                    })
                    DropdownSelectorView(
                        shouldShowDropdown: $viewModel.shouldShowFirmDropdown,
                        selectedOption:$viewModel.firmSelectedOption,
                        placeholder: viewModel.isConsultingFirmPlaceholder,
                        options: viewModel.isConsultingFirmOptions,
                        onOptionSelected: { option in
                            print(option)
                    })
                }
                
//                Text("-----------").onTapGesture {
//                    print("----\(viewModel.typeSelectedOption)")
//                    print("----\(viewModel.shouldShowTypeDropdown)")
//                    print("----\(viewModel.firmSelectedOption)")
//                    print("----\(viewModel.shouldShowFirmDropdown)")
//                }
            }
            
        }
    }
}

struct SelectorsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorsView()
    }
}
