//
//  NavigateConditionView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/01.
//

import SwiftUI

struct NavigateConditionView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NavigateConditionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigateConditionView()
    }
}

//struct NavigationCell: View {
//    var navigationItem: NavigationItem
//    var body: some View {
//        NavigationLink(destination: getDestination(from: navigationItem)) {
//            HStack {
//                Text(navigationItem.name)
//            }
//        }
//    }
//
//    func getDestination(from navItem: NavigationItem) -> AnyView {
//        if navItem.destination is ZoneList.Type {
//            return AnyView(ZonesList())
//        } else {
//            return AnyView(ListStyles())
//        }
//    }
//}
