//
//  SearchableListView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/10.
//

import Foundation
import SwiftUI

struct SearchableListView: View {
    //🌸 searchable에 쓰이는 SearchableListViewModel 전역으로 설정해주기
    //🌸앱 들어왔을 때 한번 fetch 해서 받아주고 나중에 어디서든 쓰일 수 있게 하기 위해서
    //🌸 @EnvironmentObject 로 view에서 데이터 쓸 수 있게 받아주기
    @EnvironmentObject var searchableListViewModel : SearchableListViewModel
    //        @StateObject var viewModel = SearchableListViewModel()
    @State var searchText = ""
    
    var body: some View {
        ScrollView{
            VStack{
                Text("데이터 확인 tap")
                    .onTapGesture {
                        print(searchableListViewModel.companyNameDataSource)
                    }
                VStack(alignment: .leading){
                    ForEach(searchableListViewModel.companyNameDataSource){ company in
                        Text("--------\(company.id)---\(company.company_name)-------")
                        
                    }
                }
            }
        }
        .searchable(text: $searchText, suggestions: {
//            Image(systemName: "leaf.fill")
//                .symbolRenderingMode(.multicolor)
//                .searchCompletion("green")
//            Text("Red").searchCompletion("red")
//            Text("🍒").searchCompletion("pink")
//            Circle()
//                .fill(Color.mint)
//                .frame(width: 25, height: 25)
//                .searchCompletion("mint")
            //🌸🌸🌸 입력값에 따라 가지고 있던 소스데이터 필터링해서 추천 단어 보여주기
            ForEach(searchableListViewModel.companyNameDataSource.filter { $0.company_name.localizedCaseInsensitiveContains(searchText) }) { suggestion in
                Text(suggestion.company_name)
                    .searchCompletion(suggestion.company_name)
            }
            
        })
        .onAppear{
            searchableListViewModel.fetchData()
        }
    }
}

struct SearchableListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchableListView().environmentObject(SearchableListViewModel())
    }
}
