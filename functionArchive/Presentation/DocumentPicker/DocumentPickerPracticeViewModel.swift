//
//  DocumentPickerPracticeViewModel.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/04.
//

import Foundation
import Combine

class DocumentPickerPracticeViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var imporedFiles : [FileResponse] = []
    @Published var toastState : ToastMessage = ToastMessage(message: "", isShown: false)

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

class APIFetcher {
    
    let scheme = "https"
    let host = "app.bigstepedu.com"
    let mode = "dev"
    let webPagebHost = "testapi.bigstepedu.com"
    let token = "Bearer eyJraWQiOiJyWHNhMHg1cVFiOWVuZTlyUjF4QWU1cmpGTWlPOHY0SHp1WElLY2tVdGk4PSIsImFsZyI6IlJTMjU2In0.eyJjdXN0b206Y2FyZWVyc3RlcF91c2VyX2lkIjoiODk0Iiwic3ViIjoiMzU5YzU1ZDAtYTM2ZS00Y2QwLWIzYWMtNzE4OGQ1MTU0MWVkIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5hcC1ub3J0aGVhc3QtMi5hbWF6b25hd3MuY29tXC9hcC1ub3J0aGVhc3QtMl9sYnRMblc4cVciLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOnRydWUsImNvZ25pdG86dXNlcm5hbWUiOiIzNTljNTVkMC1hMzZlLTRjZDAtYjNhYy03MTg4ZDUxNTQxZWQiLCJvcmlnaW5fanRpIjoiMTQ2Yjg0MTMtNWVlYy00MzlkLWEyZmYtYzVmMjc4MTM0NmE5IiwiYXVkIjoiM3VpbzN0djRkNmpnN2t2NTQydDNmaWwyNHQiLCJldmVudF9pZCI6IjExY2Q5MDg4LTVhMGQtNDZlYy05NTU4LTQ2MDk2YmNkYTQ2YyIsInVwZGF0ZWRfYXQiOjE2NTk1NDAxMjgsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNjU5Njg1NzIzLCJuYW1lIjoi7ZWY7Jew7KO8Iiwibmlja25hbWUiOiLtlZjsl7Dso7wiLCJwaG9uZV9udW1iZXIiOiIrODIwMTA1ODc3NDcwMCIsImV4cCI6MTY1OTc3MjEyMywiaWF0IjoxNjU5Njg1NzIzLCJqdGkiOiI5N2IwMDIyOS03ZDcxLTRkNDctYmU2Ny04ZjA3Zjc2MjEyNTciLCJlbWFpbCI6ImxsaWx5aGExMjNAbmF2ZXIuY29tIn0.pM2J1R9eanMtpu3tvh2J-AgwH3qy2EkGSat-X8tdr2D-zMfhLraHNOCxwrnnA_TC9VCF9oVyxxBXoXF2ztltB1-nw33ToFXWzj7umBBzdSXsLX74Rr1Bw4sEJkCLLknugRf1_nc5bpHHsuPv9i8XY-o9V5yQ_xlFyoWug5nVHMBbnPyZ5Vd-q2koMZVppiiidCT11-_HgVqMgXcwoFmSnHAnIXFg_f1CPO7s2duGySwUyxy37OSoDWH4XHR5cBvGZAcB_cddtEdXtkEsuv0ZnTxj0xd200Lil4-gRh4wYVCUxaXD22YXk-odads9MKAlQGi0Uo5X7o-40iVDWqQlzQ"
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
      self.session = session
    }
    
    //멘토링 신청 파일 업로드
    func postFile (fileUrl : URL, fileName : String?) -> AnyPublisher<FileResponse, Error> {
        let path = "file/upload/mentoring_class"
        return uploadFile(responseModel: FileResponse.self, path: path, fileUrl : fileUrl, fileName : fileName)
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
