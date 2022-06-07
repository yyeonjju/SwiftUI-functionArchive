import Foundation
import SwiftUI


struct TooltipFunctionView: View {
    @State private var showTooltip : Bool = false
    var items : [TooltipData] = [
        TooltipData(text: "1 -----", divider: true),
        TooltipData(text: "2 -----", divider: true),
        TooltipData(text: "3 -----", divider: true),
        TooltipData(text: "4 -----", divider: false)
    ]
    
    var numbers : [Int] = [1,2,3,4,5,6,7]
    @State private var selectedNumber = 1
    private func offsetX(_ number : Int) -> Int{
        var offsetX  : Int
        
        switch number {
        case 1 :
            offsetX = 100
        case 2 :
            offsetX = 60
        case 3 :
            offsetX = 30
        case 4 :
            offsetX = 0
        case 5 :
            offsetX = -30
        case 6 :
            offsetX = -60
        case 7 :
            offsetX = -100
        default :
            offsetX = 0
        }
        return offsetX
        
    }
    
    var body: some View {
        GeometryReader { geo in
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(numbers, id : \.self) { number in
                    Button{
                        selectedNumber = number
                        showTooltip.toggle()
                    } label : {
                        Text(String(number))
                    }
                    .padding()
//                    .frame(height: geo.size.height * 0.4)
                    .background( Color.gray)
                    .clipShape(Circle())
                    .overlay{
                        //선택한 날짜가 number이고 showTooltip이 true일 때 툴팁을 보여줌
                        //툴팁 보이는거 날짜별로 토글될 수 있도록하기 위해
                        if selectedNumber == number && showTooltip {
                            TooltipView(offsetX: offsetX(number), tooltipItems: items)
                        }
                        
                    }
                    
                }
            }
        }
//        .background(Color.blue)
        
    }
}

struct TooltipFunctionView_Previews: PreviewProvider {
    static var previews: some View {
        TooltipFunctionView()
    }
}

struct TooltipData : Identifiable {
    var text : String
    var divider : Bool
    var id : String = UUID().uuidString
}

struct TooltipView: View {
    var offsetX : Int
    var tooltipItems : [TooltipData]
    
    var body : some View {
        VStack(spacing:0){
            Image(systemName: "arrowtriangle.up.fill")
                .resizable()
                .frame(width: 16, height: 6)
                .foregroundColor(.white)
                .zIndex(1)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -4)
            
            
            VStack(){
                ForEach(tooltipItems){ item in
                    VStack{
                        HStack{
                            Text(item.text)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Spacer()
                            Text("--")
                        }
                        if item.divider {
                            Divider()
                        }
                    }
//  MenuTooltipView(text: item.text, isDivider: item.divider)
                    
                }
            }
            .padding()
            .frame(width: 250)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .offset(x: CGFloat(offsetX))
        }
// .offset(x: 100 ,y: geo.size.height * 0.04 + 50)
        .offset(y:120)
        .zIndex(2)
    }
}

//struct MenuTooltipView : View {
//    var text : String
//    var isDivider : Bool = false
//
//    var body : some View {
//        VStack(){
//            HStack{
//                Text(text)
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                Spacer()
//                Text("--")
//            }
//
//
//            if isDivider {
//                Divider()
//            }
//        }
//    }
//}


