//
//  StarRatingPracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/19.
//

import SwiftUI

struct RatingView: View {
    
    @Binding var rating: Int?
    var max: Int = 5
    
    private func starType(index: Int) -> String {
        
        if let rating = self.rating {
            return index <= rating ? "star.fill" : "star"
        } else {
            return "star"
        }
        
    }
    
    
    var body: some View {
           HStack {
               ForEach(1..<(max + 1), id: \.self) { index in
                   Image(systemName: self.starType(index: index))
                       .foregroundColor(Color.orange)
                       .onTapGesture {
                           self.rating = index
                       }
                       
               }
           }
       }
}

struct ModalState{
    var isShown : Bool
    var relatedId : Int?
    var text : String?
    var starRating : Int?
}

struct StarRatingPracticeView: View {
    @State private var feedbackModalState :ModalState = ModalState(isShown : false, relatedId: nil, text : "", starRating : 0)
    var body: some View {
        ZStack{
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            CustomNormalModal(
                showingModal: $feedbackModalState.isShown,
                header : {
                    Text("별점을 선택해주세요")
                        .font(.system(size:16, weight: .bold))

                },
                content : {
                    
                    VStack{
                        RatingView(rating: $feedbackModalState.starRating, max: 5)
                        
                        Text("\(String(feedbackModalState.starRating!)) 점 --")
                        
                        ZStack{ //TextEditor에 따로 placeholder 넣는 기능이 없어서
                            if feedbackModalState.text == "" {
                                TextEditor(text: Binding(
                                    get: {"어떤점이 좋았나요?"},
                                    set: {$0}
                                ))
                                    .disabled(true)
                                    .padding()
                                    .foregroundColor(.gray)
                                    .frame(height: 200)
                                    .colorMultiply(.gray)
                                    .background(.gray)
                                    .cornerRadius(12)
                            }
                            
                            TextEditor(text:Binding(
                                get: {feedbackModalState.text ?? ""},
                                set: {feedbackModalState.text = $0}
                            ))
                                .padding()
                                .foregroundColor(.black)
                                .frame(height: 200)
                                .colorMultiply(.gray)
                                .background(.gray)
                                .opacity(feedbackModalState.text == "" ? 0.25 : 1)
                                .cornerRadius(12)
                        }
                    }
                },
                footer : {
                    Button{
                        print("로직")
                        feedbackModalState.isShown = false //수업 취소 확인 모달은 사라지고

                    } label : {
                        Text("확인")
//                            .asGreenGradientButton()
                    }
                }
                
            )
        }
    }
}

struct StarRatingPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        StarRatingPracticeView()
    }
}


