//
//  ContentView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/01.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab : EBottomTab = .home
    
    var body: some View {
        VStack{
            switch selectedTab{
            case EBottomTab.home :
                VStack{
                    Text("home")
                }

            case EBottomTab.list :
                Landing()

            case EBottomTab.mypage :
                VStack{
                    Text("mypage")
                }

            }
            
            Spacer()
            
            MainBottomTabView(selectedTab : $selectedTab)
                .frame(alignment: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public enum EBottomTab : Hashable {
    case home, list, mypage
}



struct MainBottomTabView : View {
//    @EnvironmentObject var userRoleViewModel: UserRoleViewModel
    @Binding var selectedTab : EBottomTab
//    @Binding var educationTabTransitionFrom : EEducationPageTransitionFrom
//    @Binding var defaultChannelKeyword : EChannelKeyword
    
    var body : some View {
        HStack{
            Spacer()
            Button {
                withAnimation{
                    self.selectedTab = .home
                }
                
            } label : {
                Image(systemName: "house")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(selectedTab == .home ? .black : .gray )
            }
            Spacer()
            Button {
                withAnimation{
                    self.selectedTab = .list
                }
                
            } label : {
                Image(systemName: "list.dash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .foregroundColor(selectedTab == .list ? .black : .gray )
            }
            Spacer()
            Button {
                withAnimation{
                    self.selectedTab = .mypage
                }
                
            } label : {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .foregroundColor(selectedTab == .mypage ? .black : .gray )
            }
            Spacer()
        }
        .padding(.top,20)
        .frame(alignment: .bottom)
        .edgesIgnoringSafeArea(.all)
        .background(Color.white)
    }
}
