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
    let key: String
    let value: String

    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }
}

class DropdownSelectorViewModel : ObservableObject{
    
    
    init(){
        
    }
}
