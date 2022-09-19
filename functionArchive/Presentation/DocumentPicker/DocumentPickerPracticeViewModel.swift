//
//  DocumentPickerPracticeViewModel.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/04.
//

import Foundation
import Combine
import UIKit

class DocumentPickerPracticeViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var imporedFiles : [FileResponse] = []
    @Published var toastState : ToastMessage = ToastMessage(message: "", isShown: false)

    func uploadImage(selectedImage : UIImage) {
        APIFetcher().uploadImage(image : selectedImage)
            .receive(on: DispatchQueue.main)
            .print("✅")
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        self.toastState.isShown = true
                        self.toastState.message = "이미지파일 업로드 실패"
                        print("")
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    print("🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸")
                    print(value)
//                    self.uploadedImage = value
                    
                    self.toastState.isShown = true
                    self.toastState.message = "이미지파일 업로드 성공"

                })
            .store(in: &cancellables)
    }
    
    func uploadFile(fileUrl: URL, fileName : String? = nil) {
        print("✅✅✅✅")
        APIFetcher().postFile(fileUrl : fileUrl, fileName : fileName)
            .receive(on: DispatchQueue.main)
            .print("✅✅")
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        print("")
                        self.toastState.message = "파일 업로드 실패"
                        self.toastState.isShown = true
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    print("🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸")
                    print(value)
                    self.imporedFiles.append(value)
                    self.toastState.message = "파일 업로드 성공"
                    self.toastState.isShown = true
                    

                })
            .store(in: &cancellables)
        
    }
}

struct FileResponse : Decodable, Hashable {
    let id : Int
    let file_name : String
    let absolute_url : String
}

struct ImgageFileResponse : Decodable, Hashable {
    let id : Int
    let absolute_url : String
}

class APIFetcher {
    
    let scheme = "https"
    let host = "app.bigstepedu.com"
    let mode = "dev"
    let webPagebHost = "testapi.bigstepedu.com"
    let token = "Bearer eyJraWQiOiJyWHNhMHg1cVFiOWVuZTlyUjF4QWU1cmpGTWlPOHY0SHp1WElLY2tVdGk4PSIsImFsZyI6IlJTMjU2In0.eyJjdXN0b206Y2FyZWVyc3RlcF91c2VyX2lkIjoiNjE5Iiwic3ViIjoiMzU5YzU1ZDAtYTM2ZS00Y2QwLWIzYWMtNzE4OGQ1MTU0MWVkIiwiem9uZWluZm8iOiIgIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5hcC1ub3J0aGVhc3QtMi5hbWF6b25hd3MuY29tXC9hcC1ub3J0aGVhc3QtMl9sYnRMblc4cVciLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOnRydWUsImNvZ25pdG86dXNlcm5hbWUiOiIzNTljNTVkMC1hMzZlLTRjZDAtYjNhYy03MTg4ZDUxNTQxZWQiLCJwaWN0dXJlIjoiICIsIm9yaWdpbl9qdGkiOiI3MjA5OTQ5OS01NGEwLTQ3YzYtYjlhYS03M2NmNjZkNTQ1ZDQiLCJhdWQiOiIzdWlvM3R2NGQ2amc3a3Y1NDJ0M2ZpbDI0dCIsImV2ZW50X2lkIjoiZWNkY2MxY2EtZGM5Zi00OTM3LThjMDMtNjkwOWU0M2ZhNDA3IiwidXBkYXRlZF9hdCI6MTY1OTU0MDEyOCwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE2NjMzODc3MjMsIm5hbWUiOiLtlZjsl7Dso7wiLCJuaWNrbmFtZSI6Iu2VmOyXsOyjvCIsInBob25lX251bWJlciI6Iis4MjAxMDU4Nzc0NzAwIiwiZXhwIjoxNjYzNDc0MTIzLCJpYXQiOjE2NjMzODc3MjMsImp0aSI6IjU4OTY5ZWQ1LWM2Y2QtNDVjNC1iMDMyLTE4MGMxZGZjZDQ4NCIsImVtYWlsIjoibGxpbHloYTEyM0BuYXZlci5jb20ifQ.KDk32w8ivLknyOPc20HH4wWBmQGjM7Wedorgj4HMkaXjZMctk3w2BUWjT3Ufp8UiZBQ5F-bGvGkWGvXjVcnVspZLKP2oNELcVLDDp5HbN7Wwuvj4We-IVOpiyLeePXEDiTm95dJzMSxfVUxktkeRfP3UW_LZnxpjPb13POU07kToQuv_2hNGYEQRUm8EGBdx-aF-UZcrtFtgAQ8siazmf0wxaAR7iKlkJ3yy59ViUxaR1bivVIZrUJ7M3_-YzMLQWHlDoExfTvCOAyRscR0QKmkOfS6II6YTSkVU8B366Hbe5xac7YiNFITKHU3U0j1XsmQ0Sh48Ue1Fp992eR5DjA"
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
      self.session = session
    }
    
    //멘토링 신청 파일 업로드
    func postFile (fileUrl : URL, fileName : String?) -> AnyPublisher<FileResponse, Error> {
        let path = "file/upload/mentoring_class"
        return uploadFile(responseModel: FileResponse.self, path: path, fileUrl : fileUrl, fileName : fileName)
    }
    
    //프로필 이미지 업로드
    func uploadImage (image : UIImage) -> AnyPublisher<ImgageFileResponse, Error> {
        let path = "file/upload/profile_image"
        return uploadImage(responseModel: ImgageFileResponse.self, path: path, image : image)
    }
    
    //이미지 업로드
    private func uploadImage<T:Decodable>(responseModel:T.Type, path : String, image : UIImage ) -> AnyPublisher<T, Error> {
        let boundary = generateBoundaryString()
        let url = URL(string: "\(scheme)://\(host)/\(mode)/\(path)")
        guard let url = url else {
            return Fail(error: "Couldn't create URL" as! Error).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = NSMutableData()

        //convert to Data
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
//            return
            return Fail(error: "convert imageData error" as! Error).eraseToAnyPublisher()
            
        }
        
        httpBody.append(convertFileData(fieldName: "profile_image", fileName: "image.jpg", mimeType: "multipart/form-data", fileData: imageData, using: boundary))
        httpBody.appendString("--\(boundary)--")  // final boundary

        request.httpBody = httpBody as Data
 
        request.setValue(token, forHTTPHeaderField: "Authorization")
        return session.dataTaskPublisher(for: request)
            .print("✅")
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    //파일 업로드
    private func uploadFile<T:Decodable>(responseModel:T.Type, path : String, fileUrl : URL, fileName : String? = nil) -> AnyPublisher<T, Error> {


        let boundary = generateBoundaryString()
        let url = URL(string: "\(scheme)://\(host)/\(mode)/\(path)")
        guard let url = url else {
            return Fail(error: "Couldn't create URL" as! Error).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.httpBody = encodedBodyData
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = NSMutableData()
        
        fileUrl.startAccessingSecurityScopedResource()

        guard let fileData = try? Data(contentsOf: fileUrl) else {
            print("🌸🌸🌸🌸🌸error🌸🌸🌸🌸🌸")
            let error = URLError(.badURL, userInfo: [NSURLErrorKey: "\(scheme)://\(host)/\(mode)/\(path)"])
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let fileName = fileName {
            httpBody.append(convertFileData(fieldName: "file", fileName: fileName, mimeType: "multipart/form-data", fileData: fileData, using: boundary))
        }else {
            httpBody.append(convertFileData(fieldName: "file", fileName: fileUrl.lastPathComponent, mimeType: "multipart/form-data", fileData: fileData, using: boundary))
        }
        
        httpBody.appendString("--\(boundary)--")  // final boundary
        
        request.httpBody = httpBody as Data
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        return session.dataTaskPublisher(for: request)
            .print("✅")
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}




public func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
    let data = NSMutableData()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
    data.appendString("Content-Type: \(mimeType)\r\n\r\n")
    data.append(fileData)
    data.appendString("\r\n")
    
    return data as Data
}

public func generateBoundaryString() -> String {
    return "Boundary-\(UUID().uuidString)"
}
