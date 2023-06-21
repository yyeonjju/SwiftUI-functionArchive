//
//  StateObjectPracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2023/06/20.
//

import SwiftUI

struct ListModel : Identifiable {
    var id : Int
    var name : String
    var height : Int
}

struct StateObjectPracticeView: View {
    
//    @ObservedObject var vm : StateObjectPracticeViewModel = StateObjectPracticeViewModel()
//    @StateObject var vm : StateObjectPracticeViewModel = StateObjectPracticeViewModel()
//
//    var body: some View {
//        let _ = print("💜view 다시 그려짐")
//        VStack{
//            if vm.list == nil {
//                ProgressView("waiting..")
//            } else {
//                List(vm.list ?? []){ item in
//                    VStack{
//                        Text("이름 : \(item.name)")
//                        Text("신장 : \(String(item.height)) cm")
//                    }
//                    .padding(.vertical)
//                }
//            }
//
//        }
//        .onAppear{
//            vm.fetch()
//        }
//    }
    var body: some View {
        RandomNumberView()
    }
}

//struct StateObjectPracticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        StateObjectPracticeView()
//    }
//}
//
//class StateObjectPracticeViewModel : ObservableObject {
//    @Published var list : [ListModel]?
//
//    func fetch() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.list = [
//                ListModel(id: 1, name: "1번 이름", height: 161),
//                ListModel(id: 2, name: "2번 이름", height: 162),
//                ListModel(id: 3, name: "3번 이름", height: 163),
//                ListModel(id: 4, name: "4번 이름", height: 164),
//                ListModel(id: 5, name: "5번 이름", height: 165)
//            ]
//        }
//    }
//}

struct RandomNumberView: View {
    @State var randomNumber = 0

    var body: some View {
        let _ = print("🎀 RandomNumberView 다시 그림")
        VStack {
            Text("Random number is: \(randomNumber)")
            Button("Randomize number") {
                randomNumber = (0..<1000).randomElement()!
            }
        }.padding(.bottom)

        CounterView()
    }
}

final class CounterViewModel: ObservableObject {
    @Published var count = 0

    func incrementCounter() {
        count += 1
    }
}

struct CounterView: View {
//    @ObservedObject var viewModel = CounterViewModel()
    @StateObject var viewModel = CounterViewModel()

    var body: some View {
        let _ = print("💜 CounterView 다시 그림")
        VStack {
            Text("Count is: \(viewModel.count)")
            Button("Increment Counter") {
                viewModel.incrementCounter()
            }
        }
    }
}
