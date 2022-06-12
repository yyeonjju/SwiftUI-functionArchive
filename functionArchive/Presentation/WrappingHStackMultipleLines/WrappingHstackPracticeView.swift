
import SwiftUI

struct WrappingHstackPracticeView: View {
    @State private var totalHeight = CGFloat.zero
    
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                
                HStack {
                    AsyncImage(url: URL(string: "https://bigstep-backend-media.s3.ap-northeast-2.amazonaws.com/media/image/2020-11-18/uysxkwcfli7JesMy5wbmc.png"))
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                        .padding()
                    
                    VStack (alignment: .leading) {
                        Text("이름")
                        Text("-----전공")
                    }
                }
                
                Divider()
                
                HStack (alignment: .top) {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    VStack (alignment: .leading) {
                        Text("7월 7일")
                            .padding(2)
                        Text("오후12:00 ~ 오후1:30")
                            .padding(2)
                    }
                }
                .padding()
                
                Divider()
                
                VStack (alignment: .leading) {
                    Text("희망 토픽")
                    
                    GeometryReader{ geo in
                        self.tagsView(in: geo, tags: ["1--------", "2---", "3-", "4-----", "5--", "6-", "7----", "5--"]) //왜 겹치는게 있으면 tagsView 이상해지지..
                    }
                    .frame(height: totalHeight)
                    
                }
                .padding()
                
                Divider()
                
                VStack {
                    Text("test test test test test test ")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                        .lineLimit(nil)
                }
                .padding()
                
                VStack (spacing: 16) {
                    HStack {
                        Button {
                            print("")
                        } label: {
                            Text("일정보기")
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        
                        Button {
                            print("")
                        } label: {
                            Text("거절하기")
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.gray)
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(12)
                        }
                    }
                    
                    Button {
                        print("")
                    } label: {
                        Text("상세보기")
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color(UIColor.systemGray2))
                            .cornerRadius(12)
                        //.padding()
                    }
                }
                .padding()
            }
            
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.green, lineWidth: 1)
            )
            .padding(50)
        }
//        .onAppear{ vm.fetch(type: type, id: id) }
    }
}

extension WrappingHstackPracticeView {
//    private func tagsView(in g: GeometryProxy, tags : [String]) -> some View {
//        var width = CGFloat.zero
//        var height = CGFloat.zero
//
//        return
//        ZStack(alignment: .topLeading) {
//            ForEach(tags, id: \.self) { tag in
//                Text(tag)
//                    .padding()
//                    .foregroundColor(.gray)
//                    .frame(height: 35)
//                    .onTapGesture{
//                        print(width)
//                        print(height)
//                        print(totalHeight)
//                    }
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 24)
//                            .stroke(.gray, lineWidth: 1)
//                    )
//                    .padding([.horizontal, .vertical], 4)
//                    .alignmentGuide(.leading, computeValue: { d in //leading으로부터의 정렬 => width를 리턴 (마지막요소가 아니면 width -= d.width -> 점점 왼쪽으로부터 떨어뜨림, 마지막 요소이면 width == 0 -> 마지막 요소이면 다시 width = 0으로 돌려놈)
//                        if (abs(width - d.width) > g.size.width)
//                        { //geometry width를 넘었을때
//                            print("⭐️")
//                            print(d.height)
//                            width = 0
//                            height -= d.height
//                        }
//
//                        let result = width
//                        if tag == tags.last! { //마지막 요소일 때
//                            print("⭐️⭐️")
//                            width = 0 //last item
//
//                        } else { //마지막 요소가 아닐 때
//                            print("⭐️⭐️⭐️")
//                            print(d.width)
//                            width -= d.width
//                        }
//                        print("✅width")
//                        print(result)
//                        return result
//                    })
//                    .alignmentGuide(.top, computeValue: {d in //top으로부터의 정렬 => height를 리턴 (마지막 요소가 아니면 height == 0)
//                        let result = height
//                        if tag == tags.last! { // ⭐️⭐️⭐️⭐️아... 이거 때문에
//                            print("⭐️⭐️⭐️⭐️")
//                            height = 0 // last item
//                        }
//                        print("✅height")
//                        print(result)
//                        return result
//                    })
//            }
//        }.background(viewHeightReader($totalHeight))
//    }
    
    private func tagsView(in g: GeometryProxy, tags : [String]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return
        ZStack(alignment: .topLeading) {
            ForEach(Array(tags.enumerated()), id: \.offset) { i, tag in
                Text(tags[i])
                    .padding()
                    .foregroundColor(.gray)
                    .frame(height: 35)
                    .onTapGesture{
                        print(width)
                        print(height)
                        print(totalHeight)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(.gray, lineWidth: 1)
                    )
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in //leading으로부터의 정렬 => width를 리턴 (마지막요소가 아니면 width -= d.width -> 점점 왼쪽으로부터 떨어뜨림, 마지막 요소이면 width == 0 -> 마지막 요소이면 다시 width = 0으로 돌려놈)
                        if (abs(width - d.width) > g.size.width)
                        { //geometry width를 넘었을때
                            print("⭐️")
                            print(d.height)
                            width = 0
                            height -= d.height
                        }
                        
                        let result = width
                        if i == tags.count-1 { //마지막 요소일 때
                            print("⭐️⭐️")
                            width = 0 //last item
                            
                        } else { //마지막 요소가 아닐 때
                            print("⭐️⭐️⭐️")
                            print(d.width)
                            width -= d.width
                        }
                        print("✅width")
                        print(result)
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in //top으로부터의 정렬 => height를 리턴 (마지막 요소가 아니면 height == 0)
                        let result = height
                        if i == tags.count-1 { // ⭐️⭐️⭐️⭐️아... 이거 때문에
                            print("⭐️⭐️⭐️⭐️")
                            height = 0 // last item
                        }
                        print("✅height")
                        print(result)
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct WrappingHstackPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        WrappingHstackPracticeView()
    }
}
