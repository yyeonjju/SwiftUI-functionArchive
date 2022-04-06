//
//  Landing.swift
//  functionArchive
//
//  Created by 하연주 on 2022/04/01.
//

import Foundation
import SwiftUI

struct Landing: View {
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    NavigationLink(destination:selectResultView()){
                        Text("Multi Selection Filter")
                    }
                    NavigationLink(destination : SelectorsView()){
                        Text("Reusable Dropdown Selector")
                    }
                    NavigationLink(destination : ScoreView()){
                        Text("Practice @EnvironmentObject")
                    }
                }
            }
        }
    }
}

struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        Landing()
    }
}
