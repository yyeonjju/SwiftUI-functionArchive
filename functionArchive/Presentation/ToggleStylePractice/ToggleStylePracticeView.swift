//
//  ToggleStylePracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2023/06/03.
//

import SwiftUI

struct MyTag {
    let label : String
    let value : Int
}

struct MyTagToggles : Hashable {
    let label : String
    let value : Int
    let isOn : Bool
}

struct ToggleStylePracticeView: View {
    @State var selectedTopics : [String] = ["tag1", "tag3"]
    
    let myTags : [MyTag] =  [
        MyTag(label: "tag1", value: 1),
        MyTag(label: "tag2", value: 2),
        MyTag(label: "tag3", value: 3),
        MyTag(label: "tag4", value: 4),
        MyTag(label: "tag5", value: 5),
    ]
    
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
    
    var body: some View {
        ScrollView{
            VStack(alignment : .leading){
                Text("방법 1")
                
                VStack(alignment: .leading, spacing: 0){
                    ForEach(myTags.map{$0.label}, id : \.self){el in
                        VStack(spacing: 0){
                            HStack{
                                Button{
                                    if(selectedTopics.contains(el)){
                                        selectedTopics = selectedTopics.filter{topic in topic != el}
                                    }else{
                                        selectedTopics.append(el)
                                    }
                                }label : {
                                    HStack(alignment: .center){
                                        
                                        selectedTopics.contains(el)
                                        ?  Image(systemName:  "checkmark.circle.fill")
                                            .imageScale(.large)
                                            .foregroundColor(.green)
                                        :  Image(systemName:  "circle")
                                            .imageScale(.large)
                                            .foregroundColor(.green)
                                        
                                        
                                        Text(el)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding(5)
                                }
                                
                                Spacer()
                            }
                            
                            Divider()
                                .padding(.bottom,5)
                            
                        }
                    }
                }
                
                Text("방법 2")
                
                VStack{
                    ForEach(myTags.map{$0.label}, id : \.self){el in
                        HStack{
                            Toggle(el, isOn: binding(for:el))
                                .toggleStyle(CheckboxToggleStyle(style: .square))
                                .foregroundColor(.green)
                            Spacer()
                        }
                        
                    }
                    
                }
                
            }
            .padding(.horizontal)
        }
        
    }
}


/*
struct ToggleStylePracticeView: View {
    @State var isOn = false
    
    var body: some View {
        VStack {
            Toggle(isOn: self.$isOn) {
                Text("Toggle: \(String(self.isOn))")
            }
            .toggleStyle(CheckboxToggleStyle(style: .square))
            
//            Toggle(isOn: self.$isOn, label: {Text("Toggle: \(String(self.isOn))")})
        }
        .padding(30)
    }
}
 */


struct ToggleStylePracticeView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleStylePracticeView()
    }
}
