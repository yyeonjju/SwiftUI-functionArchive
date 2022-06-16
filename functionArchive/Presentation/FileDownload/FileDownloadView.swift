//
//  FileDownloadView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/14.
//

import SwiftUI
import Foundation

////⭐️⭐️⭐️⭐️⭐️⭐️ 1 ⭐️⭐️⭐️⭐️
//struct FileDownloadView: View {
//    @StateObject var downloadManager = DownloadManager()
//    var body: some View {
//        VStack{
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                .onTapGesture{
//                    downloadManager.downloadFile()
//                }
//                .padding(.bottom, 30)
//            if(downloadManager.isDownloading){
//                Text("다운로드 중...")
//            }
//        }
//
//
//    }
//}
//
//struct FileDownloadView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileDownloadView()
//    }
//}
//
//final class DownloadManager: ObservableObject {
//    @Published var isDownloading = false
//    @Published var isDownloaded = false
//
//    func downloadFile() {
//        print("downloadFile func start")
//        isDownloading = true
//
//        //link to the device's file manager, under the user's personal files
//        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        let destinationUrl = docsUrl?.appendingPathComponent("myVideo1.mp4")
//
//        if let destinationUrl = destinationUrl {
////            if (FileManager().fileExists(atPath: destinationUrl.path)) {
////                print("File already exists")
////                isDownloading = false
////            } else {
//                //creating an HTTP request to get the video file.
//                let urlRequest = URLRequest(url: URL(string: "https://bigstep-backend-media.s3.ap-northeast-2.amazonaws.com/media/file/2022-05-11/xuiwlzjgpndGVzdCBpbWFnZS5qcGVn.jpeg")!)
//
//                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//
//                    if let error = error {
//                        print("Request error: ", error)
//                        self.isDownloading = false
//                        return
//                    }
//
//                    guard let response = response as? HTTPURLResponse else { return }
//
//                    if response.statusCode == 200 {
//                        guard let data = data else {
//                            self.isDownloading = false
//                            return
//                        }
//                        DispatchQueue.main.async {
//                            do {
//                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
//
//                                DispatchQueue.main.async {
//                                    self.isDownloading = false
//                                    self.isDownloaded = true
//                                }
//                            } catch let error {
//                                print("Error decoding: ", error)
//                                self.isDownloading = false
//                            }
//                        }
//                    }
//                }
//                dataTask.resume()
////            }
//        }
//    }
//
////    func deleteFile() {
////        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
////
////        let destinationUrl = docsUrl?.appendingPathComponent("myVideo.mp4")
////        if let destinationUrl = destinationUrl {
////            guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
////            do {
////                try FileManager().removeItem(atPath: destinationUrl.path)
////                print("File deleted successfully")
////                isDownloaded = false
////            } catch let error {
////                print("Error while deleting video file: ", error)
////            }
////        }
////    }
//
////    func checkFileExists() {
////        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
////
////        let destinationUrl = docsUrl?.appendingPathComponent("myVideo.mp4")
////        if let destinationUrl = destinationUrl {
////            if (FileManager().fileExists(atPath: destinationUrl.path)) {
////                isDownloaded = true
////            } else {
////                isDownloaded = false
////            }
////        } else {
////            isDownloaded = false
////        }
////    }
//
////    func getVideoFileAsset() -> AVPlayerItem? {
////        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
////
////        let destinationUrl = docsUrl?.appendingPathComponent("myVideo.mp4")
////        if let destinationUrl = destinationUrl {
////            if (FileManager().fileExists(atPath: destinationUrl.path)) {
////                let avAssest = AVAsset(url: destinationUrl)
////                return AVPlayerItem(asset: avAssest)
////            } else {
////                return nil
////            }
////        } else {
////            return nil
////        }
////    }
//}


//⭐️⭐️⭐️⭐️⭐️⭐️ 2 ⭐️⭐️⭐️⭐️
struct FileDownloadView: View {
    @Environment(\.presentationMode) var presentationMode
//    @StateObject var downloadManager = DownloadManager()
    
    let url = URL(string: "https://bigstep-backend-media.s3.ap-northeast-2.amazonaws.com/media/image/2020-11-18/uysxkwcfli7JesMy5wbmc.png")
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onTapGesture{
                    FileDownloader.loadFileAsync(url: url!) { (path, error) in
                        print("PDF File downloaded to : \(path!)")
                    }
                }
                .padding(.bottom, 30)
//            if(downloadManager.isDownloading){
//                Text("다운로드 중...")
//            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("Back"){self.presentationMode.wrappedValue.dismiss()})

        
    }
}


class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void) {
        
        print("다운로드 시작 --")
//        print(url.lastPathComponent)
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else {
            print("else")
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                print(data)
                print(response)
                print(error)
                if error == nil {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            print("200")
                            if let data = data {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                                    completion(destinationUrl.path, error)
                                } else {
                                    completion(destinationUrl.path, error)
                                }
                            } else {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}
