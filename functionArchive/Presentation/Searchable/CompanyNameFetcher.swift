//
//  CompanyNameFetcher.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/10.
//

import Foundation
import Combine

struct ApiAgent {
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func networkRequest<T: Decodable>(
        _ request: URLRequest,
        _ decoder: JSONDecoder = JSONDecoder())-> AnyPublisher<Response<T>, Error> {
            
            return URLSession.shared
                .dataTaskPublisher(for: request)
//                .print("⭐️")
                .tryMap{ result in
                    //                    print(try decoder.decode(T.self, from: result.data))
                    let value = try decoder.decode(T.self, from: result.data)
                    return Response(value: value, response: result.response)
                }
//                .print("⭐️⭐️")
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
}


enum API {
    static let agent = ApiAgent()
    static var baseURL = URLComponents(string:"https://testapi.bigstepedu.com")!
    
}


extension API {
    
    // ⭐️Get
    static func getCompanyList() -> AnyPublisher<CompanyNameListResponse, Error> {
        baseURL.path = "/community/autocomplete/company"
        baseURL.queryItems = [
            URLQueryItem(name: "pageSize", value: String(100)),
            URLQueryItem(name: "q", value: "a"),
        ]
        //        let request = URLRequest(url: base.appendingPathComponent("community/interview_reviews"))
        let request = URLRequest(url: baseURL.url! )
        
        return agent.networkRequest(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    
    
}

struct CompanyNameListResponse : Codable {
    let contents : [CompanyName]
    let last : Bool
    let total : Int
    
}

struct CompanyName : Codable,Identifiable {
    let id : Int
    let company_name : String
}
