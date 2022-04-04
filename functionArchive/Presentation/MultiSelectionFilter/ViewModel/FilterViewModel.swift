//
//  FilterViewModel.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/01.
//

import Foundation

struct FilterModel :Identifiable {
    var id : Int
    var name : String
    var selected : Bool
}

//뷰모델 자체가 뷰에서 @StateObject로 인스턴스화되었기 때문에
//view가 재구성될 때마다 뷰모델도 인스턴스화된는 문제
//싱글톤 접근방식 사용?!
class FilterViewModel : ObservableObject {
    static let shared = FilterViewModel() //⭐️ 싱글톤 접근방식
    init(){}
    
    @Published var filter = [
        FilterModel(id: 0, name:"Chicago Bulls", selected:false),
        FilterModel(id: 1, name:"Cleveland Cavaliers", selected:false),
        FilterModel(id: 2, name:"Los Angeles Laker", selected:false),
        FilterModel(id: 3, name:"Miami Heat", selected:false),
        FilterModel(id: 4, name:"San Antonio Spurs", selected:false)
    ]
    
    //매개변수가 하나의 FilterModel 타입으로 들어옴
    //필터들 눌렀을 때
    func filterRowTapped (filterRow : FilterModel) {
        //filter 리스트의 해당 아이디를 통해 인덱스에 접근해서
        //selected 프로퍼티를 toggle 한다
        self.filter[filterRow.id].selected.toggle()
    }
    
    //리셋버튼
    //선택되어 있었던거는 filterRowTapped함수로 선택 안되도록 toggle해주기
    func filterReset () {
        for element in filter {
            if element.selected {
                filterRowTapped(filterRow: element)
            }
        }
    }
}
