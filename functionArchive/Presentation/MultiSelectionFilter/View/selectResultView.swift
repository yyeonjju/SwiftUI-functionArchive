//
//  selectResultView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/01.
//

import SwiftUI


struct selectResultView: View {
    //필터링 sheet가 열리는지 여부
    @State var isFilterTapped = false
    //❌ FilterViewModel를 구독하는 인스턴스 생성
//    @StateObject var filterViewModel = FilterViewModel()
    //⭐️ 싱글톤 접근방식 => 계속 다시 인스턴스화 될 필요 없다?!
    @StateObject var filterViewModel = FilterViewModel.shared
    
    var body: some View {
        VStack{
            Button("Choose"){
                //필터링 sheet가 열리는지 여부를 토글 시켜주는 버튼 (false -> true)
                isFilterTapped.toggle()
            }
            .padding([.horizontal])
            .padding(.vertical,20)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius:15))
            
            VStack{
                Text("Chosen Teams")
                .padding(30)
                
                ForEach(filterViewModel.filter) { filter in
                    if filter.selected {
                        Text("- \(filter.name)")
                            .padding()
                    }
                }
            }
            
            Button("Reset") {
                filterViewModel.filterReset()
            }
            
        }
        //isFilterTapped일 때 열리는 sheet
        .sheet(
            isPresented: $isFilterTapped,
            content: {
                Filterview(isFilterTapped:$isFilterTapped)
            
        })
    }
}

struct Filterview : View {
    @Binding var isFilterTapped :Bool
    //❌FilterViewModel를 구독하는 인스턴스 생성
    //@StateObject var filterViewModel = FilterViewModel()
    //⭐️⭐️⭐️⭐️⭐️⭐️ 싱글톤 접근방식 => 계속 다시 인스턴스화 될 필요 없다?!
    @StateObject var filterViewModel = FilterViewModel.shared
    
    var body: some View {
        HStack{
            Spacer()
            Button("Done"){
                isFilterTapped.toggle()
            }
        }
        .padding()
        
        ScrollView{
            ForEach (filterViewModel.filter) { filter in
                HStack{
                    Image(systemName :filter.selected ? "checkmark.circle.fill": "circle")
                    Text(filter.name)
                    Spacer()
                }
                .padding(.horizontal)
                .contentShape(Rectangle())
                //각 필터를 클릭했을 때
                //선택되었던건 선택 안된것으로 바꾸고 선택안되어 있었던건 선택 된것으로 바꾸는 이벱트
                .onTapGesture {
                    filterViewModel.filterRowTapped(filterRow: filter)
                }
                
            }
            
            
        }
        
        
        
    }
}

struct selectResultView_Previews: PreviewProvider {
    static var previews: some View {
        selectResultView()
    }
}
