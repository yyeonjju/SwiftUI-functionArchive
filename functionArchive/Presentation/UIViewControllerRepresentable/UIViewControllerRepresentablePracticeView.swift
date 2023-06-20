//
//  UIViewControllerRepresentablePracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2023/06/12.
//

import SwiftUI

struct UIViewControllerRepresentablePracticeView: View {
    @State private var showImagePicker : Bool = false
    @State private var selectedImage : UIImage?
    
    var body: some View {
        VStack{
            Button{
                self.showImagePicker = true
            } label : {
                Text("Open Image Picker")
                    .padding()
                    .background(.green)
                    .cornerRadius(10)
            }
            
            Button {
                print("selectedImage :", selectedImage)
            } label : {
                Text("Selected Image")
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
//        .fullScreenCover(isPresented: $showImagePicker){
//            ImagePickerPractice(image: $selectedImage, showScreen: $showImagePicker)
//        }
        .sheet(isPresented: $showImagePicker){
            ImagePickerPractice(image: $selectedImage, showScreen: $showImagePicker)
        }
    }
}

struct UIViewControllerRepresentablePracticeView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerRepresentablePracticeView()
    }
}
