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
                    Group{
                        NavigationLink(destination:selectResultView()){
                            Text("Multi Selection Filter")
                        }
                        NavigationLink(destination : SelectorsView()){
                            Text("Reusable Dropdown Selector")
                        }
                        NavigationLink(destination : ScoreView()){
                            Text("Practice @EnvironmentObject")
                        }
                        NavigationLink(destination : PostRequestPractice()){
                            Text("Post Request Practice")
                        }
                        NavigationLink(destination : SearchableListView()){
                            Text("Searchable")
                        }
                        NavigationLink(destination : SnapCarousel()){
                            Text("SnapCarousel")
                        }
                        NavigationLink(destination : FullscreenCarouselView(
                            spacing: 20,
                            itemsData: [TestStruct(), TestStruct(), TestStruct(), TestStruct()],
                            zoomFactor: 0.7){ itemData in
                                // this view is wrapped in VStack with proper width
                                VStack {
                                    VStack {
                                        Text("some thing \(itemData.test)")
                                            .frame(maxWidth: .infinity, minHeight: 100)
                                            .background(Color.red)
                                    }
                                }
                            }
                        ){
                            Text("FullscreenCarouselView")
                        }
                        NavigationLink(destination : HorizontalList()){
                            Text("HorizontalList")
                        }
                        
                        NavigationLink(destination : DatePickerView()){
                            Text("DatePicker")
                        }
                        
                        NavigationLink(destination: YearMonthPicker()){
                            Text("YearMonthPicker")
                        }
                    }
                    Group{
                        NavigationLink(destination: AutoCompleteView()){
                            Text("AutoCompleteView")
                        }
                        NavigationLink(destination : TooltipFunctionView()){
                            Text("Tooltip")
                        }
                        
                        NavigationLink(destination: AlertBackgroundView()){
                            Text("Alert")
                        }
                        NavigationLink(destination: SlotDragView()){
                            Text("Slot")
                        }
                        
                        NavigationLink(destination: WrappingHstackPracticeView()){
                            Text("Wrapping Hstack Multiple Lines Practice")
                        }
                        
                        NavigationLink(destination: ModalPracticeView()){
                            Text("Custom Modal Practice")
                        }
                        NavigationLink(destination: FileDownloadView()){
                            Text("File Download")
                        }
                        NavigationLink(destination: OpenOtherAppView()){
                            Text("Open Other App")
                        }
                        NavigationLink(destination: OpenPdfFileView()){
                            Text("Open Pdf File")
                        }
                        NavigationLink(destination: ScrollPracticeView()){
                            Text("Scroll Practice")
                        }
                        
                    }
                    
                    NavigationLink(destination : StarRatingPracticeView()){
                        Text("Star Rating Practice")
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
