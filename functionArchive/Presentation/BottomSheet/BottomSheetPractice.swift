//
//  BottomSheetPractice.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/26.
//

import SwiftUI

//https://velog.io/@kipsong/Today-I-learned-SwiftUI%EC%97%90%EC%84%9C-BottomSheet-%EB%A7%8C%EB%93%A4%EA%B8%B0
//struct BottomSheetPractice: View {
//    @State private var isTopicsShowing = false
//    var heightFactor: CGFloat {
//        UIScreen.main.bounds.height > 800 ? 3.6 : 3
//    }
//
//    var offset: CGFloat {
//        isTopicsShowing ? 0 : UIScreen.main.bounds.height / heightFactor
//    }
//
//
//    var body: some View {
//        ZStack {
//            Color.white
//                .edgesIgnoringSafeArea(.all)
//
//            Button(action: {
//                self.isTopicsShowing.toggle()
//            }) {
//                HStack {
//
//                    Text("BottomSheet 호출")
//                        .font(.system(size: 20, weight: .medium))
//                        .foregroundColor(.black)
//                        .padding(20)
//                }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(.black, lineWidth: 1)
//                )
//
//            }
//
//            // BottomSheet
//            GeometryReader { proxy in
//                VStack {
//                    Spacer()
//                    Color.blue
//                        .frame(
//                            width: proxy.size.width,
//                            height: proxy.size.height / heightFactor,
//                            alignment: .center
//                        )
//                        .offset(y: offset)
//                        .animation(.easeInOut(duration: 0.49), value: self.isTopicsShowing)
//
//                }
//            }.edgesIgnoringSafeArea(.bottom)
//        }
//    }
//}
//
//struct BottomSheetPractice_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomSheetPractice()
//    }
//}


//https://swiftwithmajid.com/2019/12/11/building-bottom-sheet-in-swiftui/
//struct BottomSheetPractice: View {
//    @State private var isOpen : Bool = false
//    let singleTextHeight : CGFloat = 30
//    let array = ["1", "2", "3", "4", "5", "6", "7", "8"]
//    var body: some View{
//        BottomSheetView(isOpen: $isOpen, maxHeight: singleTextHeight*CGFloat(array.count)) {
//            //                   Rectangle().fill(Color.red)
//            VStack{
//                ForEach(array, id: \.self){ el in
//                    Text(String(el))
//                }
//            }
//        }.edgesIgnoringSafeArea(.all)
//    }
//}
//
//fileprivate enum Constants {
//    static let radius: CGFloat = 16
//    static let indicatorHeight: CGFloat = 6
//    static let indicatorWidth: CGFloat = 60
//    static let snapRatio: CGFloat = 0.25
//    static let minHeightRatio: CGFloat = 0.3
//}
//
//struct BottomSheetView<Content: View>: View {
//    @Binding var isOpen: Bool
//
//    let maxHeight: CGFloat
//    let minHeight: CGFloat
//    let content: Content
//
//    @GestureState private var translation: CGFloat = 0
//
//    private var offset: CGFloat {
//        isOpen ? 0 : maxHeight - minHeight
//    }
//
//    private var indicator: some View {
//        RoundedRectangle(cornerRadius: Constants.radius)
//            .fill(Color.secondary)
//            .frame(
//                width: Constants.indicatorWidth,
//                height: Constants.indicatorHeight
//            )
//            .onTapGesture {
//                self.isOpen.toggle()
//            }
//    }
//
//    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
//        self.minHeight = maxHeight * Constants.minHeightRatio
//        self.maxHeight = maxHeight
//        self.content = content()
//        self._isOpen = isOpen
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(spacing: 0) {
//                self.indicator.padding()
//                self.content
//            }
//            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
//            .background(Color(.secondarySystemBackground))
//            .cornerRadius(Constants.radius)
//            .frame(height: geometry.size.height, alignment: .bottom)
//            .offset(y: max(self.offset + self.translation, 0))
//            .animation(.interactiveSpring())
//            .gesture(
//                DragGesture().updating(self.$translation) { value, state, _ in
//                    state = value.translation.height
//                }.onEnded { value in
//                    let snapDistance = self.maxHeight * Constants.snapRatio
//                    guard abs(value.translation.height) > snapDistance else {
//                        return
//                    }
//                    self.isOpen = value.translation.height < 0
//                }
//            )
//        }
//    }
//}

struct MentoringTopic {
    let label : String
    let value : Int
}

struct MentoringTopicToggles : Hashable {
    let label : String
    let value : Int
    let isOn : Bool
}

let mentoringTags : [MentoringTopic] =  [
    MentoringTopic(label: "Resume", value: 2),
    MentoringTopic(label: "자소서", value: 3),
    MentoringTopic(label: "Essay", value: 4),
    MentoringTopic(label: "실전형 Interview", value: 5),
    MentoringTopic(label: "Interview 기초", value: 6),
    MentoringTopic(label: "커뮤니케이션 스킬", value: 7),
    MentoringTopic(label: "스피치", value: 8),
    MentoringTopic(label: "커리어 패스", value: 9),
    MentoringTopic(label: "글로벌 경험", value: 10),
    MentoringTopic(label: "유학정보", value: 11),
    MentoringTopic(label: "진로", value: 12),
    MentoringTopic(label: "발표 스킬", value: 13),
]

class BottomSheetPracticeViewModel : ObservableObject {
    
    @Published var selectedTopics : [String] = ["실전형 Interview", "Resume"]
    
    
    func binding(for key: String) -> Binding<Bool> {
        print(selectedTopics)
        print(key)
        return Binding(
            get: {
                return self.selectedTopics.contains(key)
            }
            , set: {
                if($0 == false){
                    self.selectedTopics = self.selectedTopics.filter{topic in topic != key}
                } else{
                    self.selectedTopics.append(key)
                }
                
//                for k in self.selectedTopics{
//                    if(k != key) {
//                        self.selectedTopics.filter{topic in topic != k}
//                    } else {
//                        self.selectedTopics.append(key)
//                    }
//
//                }
            }
        )
    }
}


struct BottomSheetPractice: View {
    @StateObject var vm : BottomSheetPracticeViewModel = BottomSheetPracticeViewModel()
    @State private var isOpen : Bool = false
    let singleTextHeight : CGFloat = 53
//    let rowHeight = 56
//    let array = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var body: some View{
        ZStack{
            //⭐️⭐️첫번째 방법⭐️⭐️
//            BottomSheetView(isOpen: $isOpen, maxHeight: singleTextHeight*CGFloat(mentoringTags.count)+20) {
            BottomSheetView(isOpen: $isOpen, maxHeight: 470) {
                VStack(alignment: .leading, spacing: 0){
                    ScrollView{
                        ForEach(mentoringTags.map{$0.label}, id : \.self){el in
                            VStack(spacing: 0){
                                Spacer()
                                Button{
                                    if(vm.selectedTopics.contains(el)){
                                        vm.selectedTopics = vm.selectedTopics.filter{topic in topic != el}
                                    }else{
                                        vm.selectedTopics.append(el)
                                    }
                                }label : {
                                    HStack(alignment: .center){
                                        Image(systemName:  "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(vm.selectedTopics.contains(el) ? .green : .gray)
                                            
                                        Text(el)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                                Spacer()
                                Divider()
    //                                .padding(.horizontal)
                                
                            }
                            .frame(height: singleTextHeight)

                        }
                    }
                    HStack{
                        Spacer()
                        Text("설정완료")
                            .padding(20)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()

                }
            }
            .edgesIgnoringSafeArea(.all)
            
            
            //⭐️⭐️두 번째 방법⭐️⭐️
//            Text("확인")
//                .onTapGesture{
//                    print(vm.selectedTopics)
//                }
            
//            BottomSheetView(isOpen: $isOpen, maxHeight: singleTextHeight*CGFloat(mentoringTags.count)) {
//                VStack{
//                    ForEach(mentoringTags.map{$0.label}, id : \.self){el in
//                        HStack{
//                            Toggle(el, isOn: vm.binding(for:el))
//                                .toggleStyle(CheckboxToggleStyle(style: .circle, toggleDirection: .left, space : false, showDivider: true))
//                                .foregroundColor(.green)
//                            Spacer()
//                        }
//
//                    }
//                }
//            }.edgesIgnoringSafeArea(.all)
        }

    }
}

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

//⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
            )
            .onTapGesture {
                self.isOpen.toggle()
            }
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
//                    print("🍑🍑")
//                    print(value)
//                    print(state)
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}



//⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    let style: Style // custom param
    var toggleDirection : Direction = .right
    var space : Bool = true
    var showDivider : Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle() // toggle the state binding
        }, label: {
            VStack(alignment: .leading, spacing: 0){
                HStack {
                    if(toggleDirection == .left){
                        Image(systemName: configuration.isOn ? "checkmark.\(style.sfSymbolName).fill" : style.sfSymbolName)
                            .imageScale(.large)
                    }
                    
                    configuration.label
                        .foregroundColor(.black)
                    if space {
                        Spacer()
                    }
                    
                    if(toggleDirection == .right){
                        Image(systemName: configuration.isOn ? "checkmark.\(style.sfSymbolName).fill" : style.sfSymbolName)
                            .imageScale(.large)
                    }
                    
                    
                }
                .padding(5)
                
                if(showDivider){
                    Divider()
                        .padding(.horizontal)

                }
                
            }
            
            
        })
            .buttonStyle(PlainButtonStyle())
            .disabled(!isEnabled)
    }
    
    enum Style {
        case square, circle
        
        var sfSymbolName: String {
            switch self {
            case .square:
                return "square"
            case .circle:
                return "circle"
            }
        }
    }
    enum Direction {
        case right, left
    }
}

