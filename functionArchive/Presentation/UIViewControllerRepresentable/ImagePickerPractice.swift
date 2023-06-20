//
//  ImagePickerPractice.swift
//  functionArchive
//
//  Created by 하연주 on 2023/06/16.
//

import Foundation
import SwiftUI

/*
struct ImagePickerPractice : UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var showScreen: Bool //이미지 하나 선택하면 닫아주는 역할
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerPractice>) -> UIImagePickerController {
        let viewContoller = UIImagePickerController()
        viewContoller.allowsEditing = false
        viewContoller.delegate = context.coordinator
        return viewContoller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerPractice>) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, showScreen: $showScreen)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var image: UIImage?
        @Binding var showScreen: Bool
        
        init(image: Binding<UIImage?>, showScreen: Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.image = image
            showScreen = false
        }
    }
    
}
*/

struct ImagePickerPractice : UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showScreen: Bool
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerPractice>) -> UIImagePickerController {
        let viewContoller = UIImagePickerController()
        viewContoller.allowsEditing = false
        viewContoller.delegate = context.coordinator
        return viewContoller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerPractice>) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePickerPractice

        init(_ parent: ImagePickerPractice) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = image
                parent.showScreen = false
            }
        }
    }
    
}
