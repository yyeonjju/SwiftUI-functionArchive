//
//  DropdownSelectorViewModel.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/03.
//

import Foundation

//나중에 ForEach 구문에 사용할 요소들이기 떄문에 Hashable
//Identifiable 프로토콜은 struct가 id 프로퍼티를 가지고 있어야쓸 수 있다.
struct DropdownOption: Hashable {
//    let key: String
    let value: String
    let label : String

//    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
//        return lhs.key == rhs.key
//    }
}


class InterviewFilterSelectorViewModel : ObservableObject{
//    static var uniqueKey: String {
//            UUID().uuidString
//    }
    
    @Published var employmentTypePlaceholder = "고용형태"
    @Published var employmentTypeOptions :[DropdownOption] = [
        DropdownOption(value: "newcomer", label : "신입" ),
        DropdownOption(value: "experienced_worker", label : "경력직"),
        DropdownOption(value: "transitional_type_intern", label :"전환형 인턴"),
        DropdownOption(value: "general_type_intern", label : "일반 인턴"),
    ]
    @Published var typeSelectedOption : DropdownOption? = nil
    @Published var shouldShowTypeDropdown = false
    
    @Published var isConsultingFirmPlaceholder = "회사유형"
    @Published var isConsultingFirmOptions :[DropdownOption] = [
        DropdownOption(value: "false", label : "컨설팅펌 외" ),
        DropdownOption(value: "true", label : "컨설팅펌"),
    ]
    @Published var firmSelectedOption :DropdownOption? = nil
    @Published var shouldShowFirmDropdown = false
    
    
    init(){
        
    }
}
