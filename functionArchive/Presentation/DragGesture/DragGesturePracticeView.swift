//
//  DragGesturePracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2023/06/21.
//

import SwiftUI

//Identifiable : 구조체 안에 id 값이 있을 때 유효
//Hashable : 구조체 안에 id 값이 없을 때 유효

// ForEach -> id : \.offset -> .enumerated()했을 때는 이렇게!
// ForEach -> id : \.self

struct ItemModel : Hashable {
    var isOn : Bool
}
//🍇🍇🍇🍇🍇🍇🍇🍇 회사에서 썼던 드래그 관련 코드
/*
struct DragGesturePracticeView: View {
    let rows = [
        GridItem(.fixed(100))
    ]
    @State private var items : [ItemModel] = [
        ItemModel(isOn: false),
        ItemModel(isOn: true),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false),
        ItemModel(isOn: false)
    ]

    @GestureState private var location: CGPoint = .zero
    @State private var highlighted: Int? = nil

    func rectReader(index: Int) -> some View {
        return GeometryReader { (geometry) -> AnyView in
            if geometry.frame(in: .global).contains(self.location) {
                DispatchQueue.main.async {
                    if(self.highlighted != index) {
                        items[index].isOn.toggle()
                        //                            vm.items[index] = self.switchTo
                    }
                    self.highlighted = index

                }
            }
            return AnyView(Rectangle().fill(Color.clear))
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHGrid(rows: rows, alignment: .center, spacing: 2){
                ForEach(Array(items.enumerated()), id : \.offset) { index, element in
                    Button{
                        items[index].isOn.toggle()
                    } label : {
                        Rectangle()
                            .foregroundColor(element.isOn ? .green : .gray)
                            .frame(width: 30, height: 50)
                    }
                    .background(self.rectReader(index: index))
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .updating($location) { (value, state, transaction) in
                                state = value.location
                            }.onEnded {_ in
                                self.highlighted = nil
                            }
                    )
                    .allowsHitTesting(true)


                }
            }
        }
    }
}
 */

//🍇🍇🍇🍇🍇🍇🍇🍇 드래그에 따라 뷰 위치 바꾸기 https://ios-development.tistory.com/1129
/*
struct DragGesturePracticeView: View {
    @State private var draggedOffset = CGSize.zero //드래그한 만큼 뷰가 움직이도록 binding에 사용될 프로퍼티. onChanged 하는 동안 계속 위치 다시 설정
    @State private var accumulatedOffset = CGSize.zero // 지금까지 드래그 된 값을 기록하고 있는 프로퍼티. onEnded할 때 다시 위치를 저장해줌
    
    var body: some View {
        let _ = print("🍇 뷰 다시 로드")
        Circle()
          .foregroundColor(Color.blue)
          .frame(width: 100, height: 100)
          .offset(draggedOffset)
          .gesture(drag)
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                print("🍇onChanged", gesture.translation)
                draggedOffset = accumulatedOffset + gesture.translation //드래그 하는 동안 계속 뷰.offset() 위치 다시 설정
            }
            .onEnded { gesture in
                print("🍇onEnded")
                accumulatedOffset = accumulatedOffset + gesture.translation //드래그 딱 끝났을 때 현재 위치 다시 설정
            }
    }
    

}

extension CGSize {
  static func + (lhs: Self, rhs: Self) -> Self {
    CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }
}
 */


//🍇🍇🍇🍇🍇🍇🍇🍇 드레그에 따라 카드 스택뷰 rotationEffect 적용되도록 https://www.hackingwithswift.com/books/ios-swiftui/moving-views-with-draggesture-and-offset
/*
extension View {
    func stacked (at position : Int, in total : Int) -> some View {
        let offset = Double(total - position)
        return self.offset (x: 0, y: offset*10)
    }
}
struct DragGesturePracticeView : View {
    @State private var offset = CGSize.zero
    @State private var cards : [Int] = [0,1,2,3,4]
    
    
    func removeCard(at index: Int) {
        print("🍇 \(String(index)) 삭제")
        cards.remove(at: index)
    }
    
    var body: some View {
        let _ = print("🍇 뷰 다시 로드 cards :", cards)
        
        ZStack{
            Color.gray
            
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(card : cards[index]) {
                    // 이 함수가 없으면 그냥 카드가 없어지고 이 함수가 있으면 카드의 인덱스가 사라지면서 실제로 스택이 재정렬된다
                    withAnimation {removeCard(at: index)}
                }
//                    .offset(y:-(CGFloat(index) * 10))
                    .stacked(at: index, in: cards.count)

            }
        }


    }
}

struct CardView : View {
    var card : Int
    var removal : (() -> Void)?
    
    @State private var offset = CGSize.zero
    @State private var isShowingText : Bool = true
    
    var body : some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            
            Text(isShowingText ? "\(String(card))show" : "\(String(card))")
        }
        .frame(width: 350, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 10)))//가로로 움직인 것과 비례하게 rotationEffect 적용되도록
        .offset(x: offset.width * 3, y: 0) //가로로 움직인 것보다 더 움직인것 처럼 하기 위해 x: offset.width * 3
        .opacity(2 - Double(abs(offset.width / 50)))
        .onTapGesture {
            isShowingText.toggle()
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        // remove the card
                        removal?()
                        
                    } else {
                        offset = .zero
                    }
                }
        )
    }
}

*/


//⭐️⭐️⭐️⭐️⭐️⭐️ 스택오버플로우 코드 응용해서 연속적으로 선택되는 드래그 기능 만들기
//⭐️⭐️⭐️⭐️⭐️⭐️ @GestureState 프로퍼티 래퍼 이용해서
//https://stackoverflow.com/questions/59797968/swiftui-drag-gesture-across-multiple-subviews

/*
struct Player {
    var name : String
    var color : Color
    var age : Int
    var isOn : Bool
}

struct PlayerView: View {
    var scaled: Bool = false
    var player: Player
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Rectangle()
                .frame(width: 100, height: 100)
//                .foregroundColor(player.color)
                .foregroundColor(player.isOn ? .green : .gray)
                .cornerRadius(15.0)
                .scaleEffect(scaled ? 1.5 : 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.blue, lineWidth: 4)
                        .scaleEffect(scaled ? 1.5 : 1)
                )
            
            VStack {
                Text(player.name)
//                Text("Age: \(player.age)")
            }
            .padding([.top, .leading], 10)
        }
        .zIndex(scaled ? 2 : 1)
    }
}


struct DragGesturePracticeView: View {
    @State private var data: [Player] = [
        Player(name: "1", color: .green, age: 42, isOn: false),
        Player(name: "2", color: .green, age: 42, isOn: true),
        Player(name: "3", color: .green, age: 42, isOn: false),
        Player(name: "4", color: .green, age: 42, isOn: false),
        Player(name: "5", color: .green, age: 42, isOn: false),
        Player(name: "6", color: .green, age: 42, isOn: false),
        Player(name: "7", color: .green, age: 42, isOn: false),
        Player(name: "8", color: .green, age: 42, isOn: false),
        Player(name: "9", color: .green, age: 42, isOn: false),
        Player(name: "10", color: .green, age: 42, isOn: false),
        Player(name: "11", color: .green, age: 42, isOn: false),
        Player(name: "12", color: .green, age: 42, isOn: false),
    ]

    @GestureState private var location: CGPoint = .zero
    @State private var highlighted: Int? = nil
    
    let rows = [
        GridItem(.fixed(100)),
        GridItem(.fixed(100))
    ]
    
    func rectReader(index: Int) -> some View {
        return GeometryReader { (geometry) -> AnyView in
            if geometry.frame(in: .global).contains(self.location) {
 //✅ 지금 내가 드레그 하고 있는위치(self.location)가 index번째의 셀영역에 (셀의 배경 영역) 포함되어 있으면 셀의 on/off 를 토글시켜준다
 //✅ 맨 처음에 드래그가 배경 영역(rectReader)에 포함될 때는 (self.highlighted != index) 의 경우이므로 토글 시켜주고 그 이후에 드레그가 배경 영역(rectReader) 안에서 움직일 때는 토글 시켜주지 않도록
                DispatchQueue.main.async {
                    if(self.highlighted != index) {
                        self.data[index].isOn.toggle()
                    }
                    self.highlighted = index
                }
            }
            return AnyView(Rectangle().fill(Color.clear))
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHGrid(rows: rows, alignment: .center, spacing: 2) {
                ForEach(0..<data.count) { i in
                    //오.. 왜  Rectangle()만 하면 스크롤 안나오고 Button 으로 만들면 스크롤 나오지?
                    //Rectangle()만 하면 드레스 셀렉팅 작동하는데 Button 으로 만들면 작동안함
//                    Button{
//
//                    } label : {
                        PlayerView(scaled: self.highlighted == i, player: self.data[i])
                            .background(self.rectReader(index: i))
//                            .simultaneousGesture(<#T##T#>)
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                    .updating($location) { (value, state, transaction) in
                                        state = value.location
                                    }
                                    .onEnded {_ in
                                        self.highlighted = nil
                                    }
                            )
//                    }
                    

                    
                    
                }
            }
        }
//        .onDrag{
//            if(location.x)
//        }
        .onChange(of: location){ location in
            print("✅onChange location -- ", location)
            
        }
        

    }
}
*/





//❌❌❌❌❌❌ @GestureState 프로퍼티 래퍼 사용하여 뷰 이동
//@GestureState 프로퍼티 래퍼를 사용해서 DragGesture().updating 활용하여 뷰 위치 이동할 수 있음
//.updating 에서는 기본적으로 현재 드레그 위치 CGPoint 바인딩 시켜줌
//바인딩된 CGPoint 값으로 Circle()의 offset 수정자를 업데이트 시켜줄 수 있다.
//.offset(x: location.x, y: location.y)
// 하지만!!! , 드래그가 멈추고 나서 그 위치를 기억해서 가만히 있어야 하는데 @GestureState 프로퍼티 래퍼 변수는 get only 이기 때문에 DragGesture().onEnded 애서 변수 값을 다시 세팅해주지 못한다

//결론 : @GestureState로 드래그 재스쳐에 따른 뷰 이동은 만들기 복잡함..

/*
struct DragGesturePracticeView : View {
    
    @GestureState private var location : CGPoint = .zero
    //location 는 get-only 프로퍼티이기때문에
    //드레그가 끝나고 그 위치를 기억해주기 위해서 하나의 프로퍼티를 더 만든다?
    //그럼 어쨌든 두개의 프로퍼티를 만드는 것이 되기 때문에 draggedOffset,accumulatedOffset 프로퍼티를 사용한 위의 케이스와 별로 다를게 없는 듯..
    
    
    var body : some View {
        let _ = print("location", location)
        Circle()
          .foregroundColor(Color.blue)
          .frame(width: 100, height: 100)
          .offset(x: location.x, y: location.y)
          .gesture(
            DragGesture()
                .updating($location){ (value, state, transaction) in
                    print("🍇updating value", value)
                    print("🍇updating state", state)
                    state = value.location
                    print(value.location)
                    
                }
                .onEnded { gesture in
                    print("🍇onEnded", type(of: gesture.location))
                }
          )
    }
}

*/


//🍇🍇🍇🍇🍇🍇🍇🍇 드레그 하여 LazyVGrid에 있는 뷰 아이템들 위치 바꿔주기
//https://stackoverflow.com/questions/62606907/swiftui-using-ondrag-and-ondrop-to-reorder-items-within-one-single-lazygrid
//NSItemProvider??
// : drag-and-drop 또는 copy-and-paste 활동 중에 또는 호스트 앱에서 앱 확장으로 데이터 또는 파일을 프로세스 간에 전달하기 위한 항목 공급자

/*
import UniformTypeIdentifiers

struct GridData: Identifiable, Equatable {
    let id: Int
}

//MARK: - Model

class Model: ObservableObject {
    @Published var data: [GridData]
    
    let columns = [
        GridItem(.fixed(160)),
        GridItem(.fixed(160))
    ]
    
    init() {
        data = Array<GridData>(repeating: GridData(id: 0), count: 100)
        for i in 0..<data.count {
            data[i] = GridData(id: i)
        }
    }
}

//MARK: - Grid

struct DragGesturePracticeView: View {
    @StateObject private var model = Model()
    
    @State private var dragging: GridData?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: model.columns, spacing: 32) {
                ForEach(model.data) { d in
                    
//                    ZStack{
//                        Circle()
//                            .frame(width: 160, height: 160)
//                            .foregroundColor(.blue)
//
//                        Text(String(d.id))
//                            .font(.headline)
//                            .foregroundColor(.white)
//                    }
                    
                    
                    Text(String(d.id))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 160, height: 240)
                        .background(Color.green)
                        .overlay(dragging?.id == d.id ? Color.white.opacity(0.8) : Color.clear)
                        .onDrag {
                            print("🍇onDrag")
                            self.dragging = d
                            return NSItemProvider(object: String(d.id) as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: d, listData: $model.data, current: $dragging))
                }
            }
            .animation(.default, value: model.data)
        }
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: GridData
    @Binding var listData: [GridData]
    @Binding var current: GridData?

    func dropEntered(info: DropInfo) {
        print("🍇🍇 dropEntered")
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        print("🍇🍇🍇 dropUpdated")
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        print("🍇🍇🍇🍇 performDrop")
        self.current = nil
        return true
    }
}
*/


//🍇🍇🍇🍇🍇🍇🍇🍇 동시에 여러 가지 제스쳐 복합적용
//.sequenced(before: ) , .simultaneously(with: )
/*
struct DragGesturePracticeView : View {
    
    var body : some View {
        
        ScrollView{
            VStack{
                ForEach(0..<10) { i in
                    ListElem()
                        .frame(maxWidth : .infinity)
//                    Rectangle()
//                        .frame(width: 100, height: 150)
//                        .foregroundColor(.blue)
                    
                    
                    
                }
            }
        }
    }
}


struct ListElem: View {
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @GestureState var isTapping = false
    
    var body: some View {
        
        // Gets triggered immediately because a drag of 0 distance starts already when touching down.
        let tapGesture = DragGesture(minimumDistance: 0)
            .updating($isTapping) {_, isTapping, _ in
                isTapping = true
            }

        // minimumDistance here is mainly relevant to change to red before the drag
        let dragGesture = DragGesture(minimumDistance: 0)
            .onChanged { offset = $0.translation }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }
        
        let pressGesture = LongPressGesture(minimumDuration: 1.0)
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        
        // The dragGesture will wait until the pressGesture has triggered after minimumDuration 1.0 seconds.
        //⭐️⭐️ 도형이 드레그에 따라 움직이게(dragGesture) 하려면 pressGesture을 먼저 만족해야하도록
        let combined = pressGesture.sequenced(before: dragGesture)
        
        // The new combined gesture is set to run together with the tapGesture.
        //⭐️⭐️ tapGesture 와 combined 제스쳐가 동시에 인식되도록한다
        let simultaneously = tapGesture.simultaneously(with: combined)
        
        return Circle()
            .overlay(isTapping ? Circle().stroke(Color.red, lineWidth: 5) : nil) //listening to the isTapping state
            .frame(width: 100, height: 100)
            .foregroundColor(isDragging ? Color.red : Color.black) // listening to the isDragging state.
            .offset(offset)
            .gesture(simultaneously)
        
    }
}
*/


//블로그 글에 추가할 코드
struct Player : Equatable {
    var name : Int
    var isOn : Bool
}

struct PlayerView: View {
    var scaled: Bool = false
    var player: Player
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            Rectangle()
                .frame(width: 30, height: 90)
                .foregroundColor(player.isOn ? .green : .gray)
                .cornerRadius(5.0)
                .scaleEffect(scaled ? 1.5 : 1)
            
            VStack {
                Text(String(player.name))
                    .foregroundColor(.white)
            }
            .padding([.top, .leading], 10)
        }
        .zIndex(scaled ? 2 : 1)
    }
}



struct DragGesturePracticeView: View {
    @State private var data: [Player] =  [
        Player(name: 0, isOn: false),
        Player(name: 1, isOn: true),
        Player(name: 2, isOn: false),
        Player(name: 3, isOn: false),
        Player(name: 4, isOn: false),
        Player(name: 5, isOn: false),
        Player(name: 6, isOn: false),
        Player(name: 7, isOn: false),
        Player(name: 8, isOn: false),
        Player(name: 9,  isOn: false),
        Player(name: 10,  isOn: false),
        Player(name: 11,  isOn: false),
    ]

    @GestureState private var location: CGPoint = .zero
    @State private var highlighted: Int? = nil
    
    let rows = [
        GridItem(.fixed(100))
    ]
    
    func rectReader(index: Int) -> some View {
        return GeometryReader { (geometry) -> AnyView in
            if geometry.frame(in: .global).contains(self.location) {
 //✅ 지금 내가 드레그 하고 있는위치(self.location)가 index번째의 셀영역에 (셀의 배경 영역) 포함되어 있으면 셀의 on/off 를 토글시켜준다
 //✅ 맨 처음에 드래그가 배경 영역(rectReader)에 포함될 때는 (self.highlighted != index) 의 경우이므로 토글 시켜주고 그 이후에 드레그가 배경 영역(rectReader) 안에서 움직일 때는 토글 시켜주지 않도록
                DispatchQueue.main.async {
                    if(self.highlighted != index) {
                        self.data[index].isOn.toggle()
                    }
                    self.highlighted = index
                }
            }
            return AnyView(Rectangle().fill(Color.clear))
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHGrid(rows: rows, alignment: .center, spacing: 2) {
//            HStack{
                ForEach(0..<data.count, id : \.self) { i in
                        PlayerView(scaled: self.highlighted == i, player: self.data[i])
                            .background(self.rectReader(index: i))
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                    .updating($location) { (value, state, transaction) in
                                        state = value.location
                                    }
                                    .onEnded {_ in
                                        self.highlighted = nil
                                    }
                            )
                    
                }
            }
            .padding(.vertical,30)
        }
    }
}









//드레그 제스쳐에 따라 뷰를 이동하고 싶을 떄
// @State private var offset = CGSize.zero
//    .gesture(
//        DragGesture()
//            .onChanged { gesture in
//                offset = gesture.translation
//            }
//        )

