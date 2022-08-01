//
//  TopTabview.swift
//  functionArchive
//
//  Created by 하연주 on 2022/07/25.
//

import SwiftUI

struct TopTabview: View {
    @State private var selectedTab: Int = 0
    let tabs: [Tab] = [
        .init(icon: Image(systemName: "music.note"), title: "Music"),
        .init(icon: Image(systemName: "film.fill"), title: "Movies"),
        .init(icon: Image(systemName: "book.fill"), title: "Books"),
        .init(icon: Image(systemName: "book.fill"), title: "Books")
    ]
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Tabs
                Tabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)

                // Views
                TabView(selection: $selectedTab,
                        content: {
                    Text("0")
//                            Demo1View()
                                .tag(0)
//                            Demo2View()
                    Text("1")
                                .tag(1)
//                            Demo3View()
                    Text("2")
                                .tag(2)
                        })
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .foregroundColor(Color(#colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("TabsSwiftUIExample")
//            .ignoresSafeArea()
        }
    }
}

struct TopTabview_Previews: PreviewProvider {
    static var previews: some View {
        TopTabview()
    }
}


struct Tab {
    var icon: Image?
    var title: String
}
struct Tabs: View {
    var fixed = true
    var tabs: [Tab]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        // Image
                                        AnyView(tabs[row].icon)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                        // Text
                                        Text(tabs[row].title)
                                            .font(Font.system(size: 18, weight: .semibold))
                                            .foregroundColor(Color.white)
                                            .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 15))
                                    }
                                    .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 52)
                                    // Bar Indicator
                                    Rectangle().fill(selectedTab == row ? Color.white : Color.clear)
                                        .frame(height: 3)
                                }.fixedSize()
                            })
                                .accentColor(Color.white)
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .frame(height: 55)
        .onAppear(perform: {
            UIScrollView.appearance().backgroundColor = UIColor(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1))
            UIScrollView.appearance().bounces = fixed ? false : true
        })
        .onDisappear(perform: {
            UIScrollView.appearance().bounces = true
        })
    }
}
