import SwiftUI

struct HorizontalList: View {
    var body: some View {
        VStack{
            ScrollView(.horizontal,showsIndicators: false) {
                LazyHStack(spacing:20) {
                    ForEach(0...50, id: \.self) { index in
                        Text(String(index))
                            .frame(width: 300, height: 100)
                            .background(Color.red)
//                            .onAppear {
//                                print(index)
//                            }
                    }
                }
            }.frame(height:200)
            Spacer()
        }

    }
}

struct HorizontalList_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalList()
    }
}
