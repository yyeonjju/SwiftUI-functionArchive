//
//  SelectorsView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/03.
//

import Foundation
import SwiftUI

struct SelectorsView: View {
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
    
    var body: some View {
//        NavigationView{
            VStack{
                DropdownSelectorView(
                    placeholder: "Day of the week",
                    options: SelectorsView.options,
                    onOptionSelected: { option in
                        print(option)
                })
                DropdownSelectorView(
                    placeholder: "Day of the week",
                    options: SelectorsView.options,
                    onOptionSelected: { option in
                        print(option)
                })
            }
//        }
        
    }
}

struct SelectorsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorsView()
    }
}
