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

            PHPhotoLibrary.requestAuthorization { (status) in
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
    
    func getAllImages(){
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        
        let req = PHAsset.fetchAssets(with: .image, options: .none)

        print(req)
        DispatchQueue.global(qos: .background).async {
            
           let options = PHImageRequestOptions()
           options.isSynchronous = true
                
        // New Method For Generating Grid Without Refreshing....
            
            //🍑🍑🍑2222🍑🍑🍑
            for i in 0..<self.imageLimit {
                PHCachingImageManager.default().requestImage(for: req[i], targetSize: CGSize(width: 150, height: 150), contentMode: .default, options: options) { (image, _) in

                    if let image = image{
                        let data1 = Images(image: image, selected: false, asset: req[i])

                        self.images.append(data1)

                    }
                }
            }
        }
    }
}

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
