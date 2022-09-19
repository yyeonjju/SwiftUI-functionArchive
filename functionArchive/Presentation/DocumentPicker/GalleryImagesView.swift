//
//  GalleryImagesView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/05.
//

import SwiftUI
import Photos

struct GalleryImagesView : View {
    @Binding var show : Bool
    @Binding var selecedImage : UIImage?
    
//    @State private var grid : [[Images]] = []
    @State private var disabled = false
    private let imageLimit : Int = 9
    @State private var images : [Images] = []
   
    
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                if !self.images.isEmpty{
                    
//                    HStack{
//
//                        Text("Pick a Image")
//                            .fontWeight(.bold)
//
//                        Spacer()
//                    }
//                    .padding(.leading)
//                    .padding(.top)
//                    Text("확인")
//                        .onTapGesture{
//                            print(self.images)
//                        }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        //🍑🍑🍑2222🍑🍑🍑
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)){
                            ForEach(self.images, id : \.self){ j in
                                ImageCard(
                                    data: j,
                                    selecedImage : self.$selecedImage,
                                    show : self.$show
                                )
                            }
                            .padding(.bottom)
                        }

                    }
                
                    
                }
                else{
                    
                    if self.disabled{
                        
                        Text("Enable Storage Access In Settings !!!")
                    }
                    if self.images.count == 0{
                        ProgressView()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 1.5)
            .background(Color.white)
            .cornerRadius(12)
        }
        .onAppear {

            PHPhotoLibrary.requestAuthorization { (status) in // 사용자가 갤러리에 접근 권한을 허용했다면
                print("🍑status🍑")
                print(status)
                if status == .authorized{
                    print("🍑authorized🍑")
                    self.getAllImages()
                    self.disabled = false
                }
                else{
                    print("🍑not authorized🍑")
                    self.disabled = true
                }
            }
        }
    }
    
    func getAllImages(){ //PHFetchOptions(), PHAsset, PHImageRequestOptions, PHCachingImageManager
        let opt = PHFetchOptions()
        opt.fetchLimit = self.imageLimit
//        opt.includeHiddenAssets = true
        opt.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

//        let req = PHAsset.fetchAssets(with: .image, options: .none)
        let req = PHAsset.fetchAssets(with: opt)

        print("🍑🍑🍑req🍑🍑🍑", req)
        DispatchQueue.global(qos: .background).async {

           let options = PHImageRequestOptions()
            print("🍑🍑🍑options🍑🍑🍑", options)
           options.isSynchronous = true

        // New Method For Generating Grid Without Refreshing....

            //🍑🍑🍑2222🍑🍑🍑
            for i in 0..<self.imageLimit {
                PHCachingImageManager.default().requestImage(for: req[i], targetSize: CGSize(width: 150, height: 150), contentMode: .default, options: options) { (image, _) in

                    print("🍑🍑🍑image🍑🍑🍑", image)
                    
                    if let image = image{
                        let data1 = Images(image: image, selected: false, asset: req[i])

                        self.images.append(data1)

                    }
                }
            }
        }
    }
    
//    func getAllImages(){
//
//        let fetchOption = PHFetchOptions()
//        fetchOption.fetchLimit = 1
//        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
//        if let photo = fetchPhotos.firstObject {
//            DispatchQueue.main.async {
//
//                ImageManager.shared.requestImage(from: photo, thumnailSize:  CGSize(width: 50, height: 50)) { image in
//                    if let image = image{
//                        print("가져온 한 장의 이미지로 (image 파라미터) 하고싶은 행동")
//                        self.images.append(image)
//    //                // 가져온 이미지로 (image 파라미터) 하고싶은 행동
//                    }
//
//                }
//           }
//        } else {
//            print("가져올 한 장의 사진이 없음????")
//            // 사진이 없을 때, 디폴트 이미지 지정
////            self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
//        }
//    }
}

//class ImageManager {
//    static let shared = ImageManager()
//
//    private let imageManager = PHImageManager()
//
//    func requestImage(from asset: PHAsset, thumnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
//        self.imageManager.requestImage(for: asset, targetSize: thumnailSize, contentMode: .aspectFill, options: nil) { image, info in
//            completion(image)
//        }
//    }
//}

struct ImageCard : View {
    
    @State var data : Images
    @Binding var selecedImage : UIImage?
    @Binding var show : Bool
    
    var body: some View{
        
        ZStack{
            
            Image(uiImage: self.data.image)
            .resizable()
            
            if self.data.selected{
                
                ZStack{
                    
                    Color.black.opacity(0.5)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
            
        }
        .frame(width: (UIScreen.main.bounds.width - 80) / 3, height: 90)
        .onTapGesture {
            self.selecedImage = data.image
        }
        
    }
}
