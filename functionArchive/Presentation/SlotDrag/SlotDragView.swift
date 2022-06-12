//
//  SlotDragView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/08.
//

import SwiftUI

struct SlotDragView: View {
    @State private var items = [Bool](repeating: false, count: 50)
    
    let rows = [
        GridItem(.fixed(100))
    ]
    @GestureState private var location: CGPoint = .zero
    @State private var highlighted: Int? = nil
    
    var body: some View {
        VStack{
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                LazyHGrid(rows: rows, alignment: .center, spacing: 2) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, element in
                        
                        VStack {
                            HStack (spacing: 2) {
                                VStack (alignment: index % 2 == 0 ? .trailing : .leading, spacing: 0) {
                                    
                                    HStack (spacing: 2) {
                                        
                                        if (index % 2 == 0) { //index가 짝수일 때 0,2,4,6... - (시간)
                                            Text("\((index / 2), specifier: "%.02d")") //"%.02d" 숫자 두자리로 표현
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                            
                                            Text(":")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                            
                                        } else { //index가 홀수일 때 1,3,5,7... - (:00)
                                            Text("00")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                            
                                            Text("")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    HStack (spacing: 2) {
                                        Button(action: { items[index].toggle() }) {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                        }
                                        .frame(width: 30)
                                        
                                        if (index % 2 == 0)
                                        {
                                            Divider()
                                        }
                                    }
                                    .frame(height: 30)
                                    
                                    HStack (spacing: 2) {
                                        Button(action: { items[index].toggle() }) {
                                            Rectangle()
                                                .foregroundColor(
                                                    index == 0 || index == 49
                                                    ? .clear
                                                    : element == true
                                                    ? .green
                                                    : .gray
                                                )
                                        }
                                        .frame(width: 30)
                                        
                                        if (index % 2 == 0)
                                        {
                                            Divider()
                                        }
                                    }
                                    .frame(height: 50)
                                    .background(self.rectReader(index: index))
                                    .highPriorityGesture(
                                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                            .updating($location) { (value, state, transaction) in
                                                state = value.location
                                            }.onEnded {_ in
                                                self.highlighted = nil
                                            }
                                    )
                                    
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(height: 50)
                                }
                            }
                        }
                    }
                }
            }
            
        }
//        .onAppear {
//            vm.fetch(date: date)
//        }
//        .onChange(of: date){ value in
//            vm.fetch(date: value)
//        }
//        .onChange(of: vm.items){ value in
//            isEdited = value == vm.existingItems ? false : true
//        }
    }
    
    func rectReader(index: Int) -> some View {
        return GeometryReader { (geometry) -> AnyView in
            if geometry.frame(in: .global).contains(self.location) {
                DispatchQueue.main.async {
                    if(self.highlighted != index) {
                        items[index].toggle()
                        //                            vm.items[index] = self.switchTo
                    }
                    self.highlighted = index
                    
                }
            }
            return AnyView(Rectangle().fill(Color.clear))
        }
    }
}

struct SlotDragView_Previews: PreviewProvider {
    static var previews: some View {
        SlotDragView()
    }
}
