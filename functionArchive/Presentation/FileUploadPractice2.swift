//
//  FileUploadPractice2.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/24.
//

import SwiftUI

struct FileUploadPractice2: View {
    @State private var isImporting: Bool = false
    
    var body: some View {
        VStack{
            Button{
                isImporting = true
            }label : {
                Text("파일 첨부하기")
                    .padding()
                    .frame(maxWidth : .infinity)
                    .background(.gray)
                    .cornerRadius(12)
            }
            
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.jpeg, .pdf, .png],
            allowsMultipleSelection: false
        ) { result in
            do{

                guard let selectedFile: URL = try result.get().first else { return }
//                    print("🌸🌸")
//                    print(selectedFile)
//                file:///private/var/mobile/Library/Mobile%20Documents/com~apple~CloudDocs/Downloads/Building%20a%20Rating%20View%20in%20SwiftUI%20%20by%20Mohammad%20Azam%20%20Medium.pdf
//                mentoringCreateVM.uploadFile(fileUrl: selectedFile)
            } catch{
                
            }
        }
    }
}

struct FileUploadPractice2_Previews: PreviewProvider {
    static var previews: some View {
        FileUploadPractice2()
    }
}
