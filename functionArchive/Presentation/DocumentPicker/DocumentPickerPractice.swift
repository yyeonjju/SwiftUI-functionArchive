//
//  DocumentPickerPractice.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/03.
//

import SwiftUI
import Combine
import Photos

struct Images: Hashable {
    
    var image : UIImage
    var selected : Bool
    var asset : PHAsset
}

struct SelectedImages: Hashable{
    
    var asset : PHAsset
    var image : UIImage
}


struct DocumentPickerPractice: View {
    @StateObject var vm : DocumentPickerPracticeViewModel = DocumentPickerPracticeViewModel()
    @State private var isPresented : Bool = false
    @State private var showFilePicker : Bool = false
    @State private var showImagePicker : Bool = false
//    @State private var userImage : UIImage?
    @State private var isImageChanged : Bool = false
    
//    @State var selected : [SelectedImages] = []
//    @State var show = false
    @State var selecedRecentImage : UIImage? = nil
    
    //이미지나 파일중에 하나 선택하는 순간!! 성공하면  fullScreenCover 꺼지고
    //해당 이미지or파일이 업로드 될 수 있도록
    //UIImage to url 타입으로 바꿀 수 있나?? 이미지를  url
    //아니면 UIImage -> Data -> url
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print("🌸paths")
//        print(paths)
        return paths[0]
    }
    
    var body: some View {
        VStack{
            ForEach(vm.imporedFiles,  id : \.self) { file in
                Text(file.file_name)
            }
            
            Button{
                isPresented = true
            }label : {
                Text("파일 첨부")
            }
        }
        .fullScreenCover(isPresented: $isPresented){
            ScrollView{
                VStack(alignment: .leading){
                    Button{
                        isPresented = false
                    } label : {
                        Text("닫기")
                    }
                    
                    HStack{
                        Spacer()
                        Button{
                            showImagePicker = true
                        } label : {
                            VStack{
                                Rectangle()
                                    .foregroundColor(Color.gray)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(15)
                                    .padding(.bottom)
                                Text("갤러리")
                            }
                            
                        }
                        Spacer()
                        
                        Button{
                            showFilePicker = true
                        } label : {
                            VStack{
                                Rectangle()
                                    .foregroundColor(Color.gray)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(15)
                                    .padding(.bottom)
                                Text("내 파일")
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 30)
                    
                    Text("최근 이미지")
                    GalleryImagesView(show: self.$isPresented, selecedImage : self.$selecedRecentImage)
                    
                    
//                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3)){
//                        ForEach(1..<10, id : \.self){ el in
//                            Rectangle()
//                                .foregroundColor(Color.gray)
//                                .frame(width: 100, height: 100)
//                                .padding(2)
//                        }
//                    }
                   
                    
                    

                }
            }
            .padding()
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.jpeg, .pdf, .png],
                allowsMultipleSelection: false
            ) { result in
                do{
                    guard let selectedFile: URL = try result.get().first else { return }
                    isPresented = false
                    
                    vm.uploadFile(fileUrl: selectedFile)
                    
                } catch{
                    
                }
            }
            .fullScreenCover(isPresented: $showImagePicker){
                ImagePicker(
                    sourceType: .photoLibrary,
                    selectedImage: Binding(
                        get: {UIImage()},
                        set: {
                            self.selecedRecentImage = $0
                            isPresented = false
  
//                            if let data = $0.jpegData(compressionQuality: 0.1) {
//                                let fileURL = getDocumentsDirectory().appendingPathComponent("copy.jpg")
//                                vm.uploadFile(fileUrl: fileURL, fileName: "galleryImage.jpg")
//                            }
//                            vm.uploadImage(selectedImage: image!)

                        }
                    ),
                    isImageChanged : $isImageChanged
                )
            }

        }
        .toast(
            message: vm.toastState.message,
            isShowing: $vm.toastState.isShown,
            duration: Toast.long
        )
        .onChange(of: selecedRecentImage){ image in
            if(image != nil){
                isPresented = false
                
//                if let data = image!.jpegData(compressionQuality: 0.1) {
//                    let fileURL = getDocumentsDirectory().appendingPathComponent("copy.jpg")
//                    vm.uploadFile(fileUrl: fileURL, fileName: "galleryImage.jpg")
//                }
                vm.uploadImage(selectedImage: image!)
            }
        }
        
        
    }
    
}

struct DocumentPickerPractice_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPickerPractice()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    @Binding var isImageChanged : Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isImageChanged = true
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct ToastMessage {
    var message : String
    var isShown : Bool
}


struct Toast: ViewModifier {
  // these correspond to Android values f
  // or DURATION_SHORT and DURATION_LONG
  static let short: TimeInterval = 2
  static let long: TimeInterval = 3.5

  let message: String
  @Binding var isShowing: Bool
  let config: Config

  func body(content: Content) -> some View {
    ZStack {
      content
      toastView
    }
  }

  private var toastView: some View {
    VStack {
      Spacer()
      if isShowing {
        Group {
          Text(message)
            .multilineTextAlignment(.center)
            .foregroundColor(config.textColor)
            .font(config.font)
            .padding(8)
        }
        .background(config.backgroundColor)
        .cornerRadius(8)
        .onTapGesture {
          isShowing = false
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
            isShowing = false
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 18)
    .animation(config.animation, value: isShowing)
    .transition(config.transition)
  }

  struct Config {
    let textColor: Color
    let font: Font
    let backgroundColor: Color
    let duration: TimeInterval
    let transition: AnyTransition
    let animation: Animation

    init(textColor: Color = .white,
         font: Font = .system(size: 14),
         backgroundColor: Color = .black.opacity(0.588),
         duration: TimeInterval = Toast.short,
         transition: AnyTransition = .opacity,
         animation: Animation = .linear(duration: 0.3)) {
      self.textColor = textColor
      self.font = font
      self.backgroundColor = backgroundColor
      self.duration = duration
      self.transition = transition
      self.animation = animation
    }
  }
}

extension View {
  func toast(message: String,
             isShowing: Binding<Bool>,
             config: Toast.Config) -> some View {
    self.modifier(Toast(message: message,
                        isShowing: isShowing,
                        config: config))
  }

  func toast(message: String,
             isShowing: Binding<Bool>,
             duration: TimeInterval) -> some View {
    self.modifier(Toast(message: message,
                        isShowing: isShowing,
                        config: .init(duration: duration)))
  }
}

