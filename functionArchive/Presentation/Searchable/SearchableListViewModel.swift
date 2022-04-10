//
//  SearchableListViewModel.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/10.
//
import Foundation
import Combine

class SearchableListViewModel: ObservableObject, Identifiable{
    @Published var companyNameDataSource: [CompanyName] = []
    private var disposables = Set<AnyCancellable>()
    
    init(){}
    
    func fetchData() {
        API.getCompanyList()
//            .map { response in
//                response.contents.map(InterviewRowViewModel.init)
//            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        //이벤트가 실패한 경우에,dataSource는 비어있는 배열을 설정
                        self.companyNameDataSource = []
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self = self else { return }
//                              print(value)
                    self.companyNameDataSource = value.contents
                })
            .store(in: &disposables)
    }

    
    
}







