//
//  PostRequestPractice.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/07.
//

import Foundation
import SwiftUI

//⭐️ POST body 부분을 먼저 작성하고
//⭐️ JSONENcoder()로 encode 시킨 뒤
//⭐️URLSession.up;oadTssk(with : request, from: encidedBody) or URLSession.dataTaskPublisher(for: ) 로 마무리

//http body로는 이 데이터를 넘겨야 한다.
//{
//rating: 10,
//writer: "두근반 세근반",
//movie_id: "5a54c286e8a71d136fb5378e",
//contents:"정말 다섯 번은 넘게 운듯 ᅲᅲᅲ 감동 쩔어요.꼭 보셈 두 번 보셈"
//}

//⭐️⭐️⭐️ Codable struct 만들어주기 : Codable = Encodable + Decodable
struct PostComment: Codable {
    let movieId: String
    let rating: Double
    let writer: String
    let contents: String

    enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case movieId = "movie_id"
        //⭐️⭐️⭐️ JSON 으로 인코딩 할 때 movieId라는 키는 movie_id로 바꾸어준다
    }
}


class PostRequestPracticeViewModel : ObservableObject {
    
    func postComment(comment : PostComment) {

        // 넣는 순서도 순서대로여야 하는 것 같다.
//        let comment = PostComment(movieId: movieId, rating: rating, writer: writer, contents: contents)
        //⭐️⭐️⭐️ body에 넣어줄 데이터 인코딩
        guard let uploadData = try? JSONEncoder().encode(comment)
        else {return}

        //⭐️⭐️⭐️ URL 객체 정의
        let url = URL(string: "https://connect-boxoffice.run.goorm.io/comment")

        //⭐️⭐️⭐️ URLRequest 객체를 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        //⭐️⭐️⭐️ HTTP 메시지 헤더
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        //⭐️⭐️⭐️
        // URLSession 객체를 통해 전송, 응답값 처리
//        print("인코딩하기 전 comment --- \(comment)")
//        print("uploadData --- \(uploadData)")
//        let decoded = try? JSONDecoder().decode(PostComment.self, from: uploadData)
//        print("다시 디코딩 --- \(decoded)")
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in

            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                print("error")
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            print("comment post success")
        }
        // POST 전송
        task.resume()
    }
}



struct PostRequestPractice: View {
    @StateObject var viewModel = PostRequestPracticeViewModel()
    
    @State private var comment = PostComment(movieId : "1", rating : 3.0, writer : "yyeon", contents : "최고")
    
    var body: some View {
        Text("POST 하기~~!!")
            .onTapGesture {
                viewModel.postComment(comment: comment)
            }
    }
}

struct PostRequestPractice_Previews: PreviewProvider {
    static var previews: some View {
        PostRequestPractice()
    }
}
