//
//  FileUploadPractice.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/22.
//

import SwiftUI
import UniformTypeIdentifiers
import Combine
import Foundation

//⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 1 ⭐️⭐️⭐️⭐️⭐️⭐️
//https://betterprogramming.pub/importing-and-exporting-files-in-swiftui-719086ec712
struct FileUploadPractice: View {
    @State private var document: MessageDocument = MessageDocument(message: "Hello, World!")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    @StateObject var vm : FileUploadPracticeViewModel = FileUploadPracticeViewModel()

    var body: some View {
        VStack {
                   GroupBox(label: Text("Message:")) {
                       //문서의 message 속성에 바인딩된 TextEditor 요소를 생성하여 메시지를 편집할 수 있다
                       TextEditor(text: $document.message)
                   }
                   GroupBox {
                       HStack {
                           Spacer()

                           Button(action: { isImporting = true }, label: {
                               Text("Import")
                           })

                           Spacer()

                       }
                   }
               }
               .padding()
               .fileImporter(
                   isPresented: $isImporting,
                   allowedContentTypes: [.jpeg, .pdf, .png], //allowedContentTypes 속성은 사용자의 선택을 제한하는 UTType 유형의 배열을 사용
                   allowsMultipleSelection: false // 둘 이상의 파일을 선택하도록 하려면 allowMultipleSelection을 true로 설정할 수도 있지만 이 간단한 예에서는 한 번에 하나의 파일만 가져올 수 있습니다.
               ) { result in
                   do{
                       guard let selectedFile: URL = try result.get().first else { return }
                       print(selectedFile)
                       print(type(of : result))
                       vm.uploadFile(fileUrl: selectedFile)
                   } catch{
                       
                   }
                   
//                   do {
//                       guard let selectedFile: URL = try result.get().first else { return }
//                       guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
//
//                       document.message = message
//                   } catch {
//                       // Handle failure.
//                   }
               }
    }
}


class FileUploadPracticeViewModel : ObservableObject{
    func uploadFile(fileUrl: URL) {
        
        let boundary = generateBoundaryString()
//    https://testapi.bigstepedu.com/mentoring/mentoring_class/file
        var baseURL = URLComponents(string:"https://testapi.bigstepedu.com")!
        baseURL.path = "/mentoring/mentoring_class/file"
//        baseURL.queryItems = [
//            URLQueryItem(name: "upload_preset", value: "hfs0tyxc"),
//        ]
        var request = URLRequest(url: baseURL.url!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
        
        var httpBody = NSMutableData()
        print(fileUrl)
//        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        guard let fileData = try? Data(contentsOf: fileUrl) else {return}
        print("⭐️⭐️")
        print(fileData)
        httpBody.append(convertFileData(fieldName: "file", fileName: fileUrl.lastPathComponent, mimeType: "multipart/form-data", fileData: fileData, using: boundary))
        httpBody.appendString("--\(boundary)--")  // final boundary
        
        request.httpBody = httpBody as Data
//        print(String(decoding: request.httpBody!, as: UTF8.self)) //확인 완

        // request
        URLSession
            .shared
            .dataTask(with: request) { data, response, error in
            print(response)

        }.resume()
    }
}

extension FileUploadPracticeViewModel {
    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}


extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}


struct FileUploadPractice_Previews: PreviewProvider {
    static var previews: some View {
        FileUploadPractice()
    }
}

//텍스트 파일과 주고받는 메시지를 인코딩하고 디코딩하는 데 필요
struct MessageDocument: FileDocument {

    static var readableContentTypes: [UTType] { [.plainText] }

    var message: String

    init(message: String) {
        self.message = message
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }

}


//⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 2 ⭐️⭐️⭐️⭐️⭐️⭐️
//struct FileUploadPractice: View {
//    var body : some View{
//        VStack{
//
//        }
//    }
//}
//
//struct FileUploadPractice_Previews: PreviewProvider {
//    static var previews: some View {
//        FileUploadPractice()
//    }
//}
//
//
//
//class FileUploader: NSObject {
//    typealias Percentage = Double
//    typealias Publisher = AnyPublisher<Percentage, Error>
//
//    private typealias Subject = CurrentValueSubject<Percentage, Error>
//
//    private lazy var urlSession = URLSession(
//        configuration: .default,
//        delegate: self,
//        delegateQueue: .main
//    )
//
//    private var subjectsByTaskID = [Int : Subject]()
//
//    func uploadFile(at fileURL: URL,
//                    to targetURL: URL) -> Publisher {
//        var request = URLRequest(
//            url: targetURL,
//            cachePolicy: .reloadIgnoringLocalCacheData
//        )
//
//        request.httpMethod = "POST"
//
//        let subject = Subject(0)
//        var removeSubject: (() -> Void)?
//
//        let task = urlSession.uploadTask(
//            with: request,
//            fromFile: fileURL,
//            completionHandler: { data, response, error in
//                // Validate response and send completion
//                //...
//                subject.send(completion: .finished)
//                removeSubject?()
//            }
//        )
//
//        subjectsByTaskID[task.taskIdentifier] = subject
//        removeSubject = { [weak self] in
//            self?.subjectsByTaskID.removeValue(forKey: task.taskIdentifier)
//        }
//
//        task.resume()
//
//        return subject.eraseToAnyPublisher()
//    }
//}
//
//extension FileUploader: URLSessionTaskDelegate {
//    func urlSession(
//        _ session: URLSession,
//        task: URLSessionTask,
//        didSendBodyData bytesSent: Int64,
//        totalBytesSent: Int64,
//        totalBytesExpectedToSend: Int64
//    ) {
//        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
//        let subject = subjectsByTaskID[task.taskIdentifier]
//        subject?.send(progress)
//    }
//}



