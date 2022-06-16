//
//  OpenPdfFileView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/16.
//

import SwiftUI
import PDFKit

//✅✅✅✅✅✅✅✅✅✅ 방법1 ✅✅✅✅✅✅✅✅✅✅✅
//⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
//https://stackoverflow.com/questions/65658339/how-to-implement-pdf-viewer-to-swiftui-application
//https://stackoverflow.com/questions/72359099/swift-ui-and-pdfkit-how-do-i-update-my-page-programmatically
//struct OpenPdfFileView: View {
//    @State private var fileData : Data?
//
//    var body: some View {
//        VStack{
//            NavigationLink {
//                PDFKitRepresentedView(fileData ?? Data(), singlePage: false)
//            } label: {
//                Text("open PDF page")
//            }
//
//
//        }
//        .onAppear{
//            self.fileData = try? Data(contentsOf: URL(string:"https://bigstep-backend-media.s3.ap-northeast-2.amazonaws.com/media/file/2021-08-02/kzmxcwaqslQ2FzZSBub3RlICMxX-yduOyImOulvCDqsrDsoJXtlZjquLDquYzsp4BfRGFuaWVsX3YxLjZf7JuM7YSw66eI7YGsIOy2lOqwgC5wZGY.pdf")!)
//        }
////        ZStack{
////            Text("open PDF")
////                .onTapGesture{
////                    self.data = try? Data(contentsOf: URL(string:"https://bigstep-backend-media.s3.ap-northeast-2.amazonaws.com/media/file/2021-08-02/kzmxcwaqslQ2FzZSBub3RlICMxX-yduOyImOulvCDqsrDsoJXtlZjquLDquYzsp4BfRGFuaWVsX3YxLjZf7JuM7YSw66eI7YGsIOy2lOqwgC5wZGY.pdf")!)
////                }
////
////            if(data != nil) {
////                    PDFKitRepresentedView(data ?? Data(), singlePage: false)
////
////            }
////        }
//
//    }
//}
//
//struct OpenPdfFileView_Previews: PreviewProvider {
//    static var previews: some View {
//        OpenPdfFileView()
//    }
//}
//
//
//struct PDFKitRepresentedView: UIViewRepresentable {
//    typealias UIViewType = PDFView
//
//    let data: Data
//    let singlePage: Bool
//
//    init(_ data: Data, singlePage: Bool = false) {
//        self.data = data
//        self.singlePage = singlePage
//    }
//
//    func makeUIView(context _: UIViewRepresentableContext<PDFKitRepresentedView>) -> UIViewType {
//        // Create a `PDFView` and set its `PDFDocument`.
//        let pdfView = PDFView()
//        pdfView.document = PDFDocument(data: data)
//        pdfView.autoScales = true
//        if singlePage {
//            pdfView.displayMode = .singlePage
//        }
//
//
//        return pdfView
//    }
//
//    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitRepresentedView>) {
//        pdfView.document = PDFDocument(data: data)
//    }
//}

//✅✅✅✅✅✅✅✅✅✅ 방법2 ✅✅✅✅✅✅✅✅✅✅✅
//⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
//https://stackoverflow.com/questions/65658339/how-to-implement-pdf-viewer-to-swiftui-application
//https://stackoverflow.com/questions/72359099/swift-ui-and-pdfkit-how-do-i-update-my-page-programmatically
struct OpenPdfFileView: View {
    var body: some View {
        VStack{
            NavigationLink {
                PDFKitRepresentedView(URL(string:"https://bigstep-backend-media.s3.ap-northeast-2.amazonaws.com/media/file/2021-08-02/kzmxcwaqslQ2FzZSBub3RlICMxX-yduOyImOulvCDqsrDsoJXtlZjquLDquYzsp4BfRGFuaWVsX3YxLjZf7JuM7YSw66eI7YGsIOy2lOqwgC5wZGY.pdf")! , singlePage: false)
            } label: {
                Text("open PDF page")
            }
        }
    }
}

struct OpenPdfFileView_Previews: PreviewProvider {
    static var previews: some View {
        OpenPdfFileView()
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    let singlePage: Bool

    init(_ url: URL, singlePage: Bool = false) {
        self.url = url
        self.singlePage = singlePage
    }

    func makeUIView(context : Context) -> UIView {
        guard let document = PDFDocument(url: self.url) else { return UIView() }
        
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        
        
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context : Context) {
    }
}


//⭐️⭐️⭐️⭐️⭐️⭐️
//https://blog.techchee.com/pdf-composer-app-swiftui/

////⭐️⭐️⭐️⭐️⭐️⭐️프로젝트 번들에 있는것만 가능?
//https://codecrew.codewithchris.com/t/how-to-view-a-pdf-file-in-swiftui/16461/2
//struct OpenPdfFileView: View {
//    let pdfDoc: PDFDocument
//
//    init() {
//        //for the sake of example, we're going to assume
//        //you have a file Lipsum.pdf in your bundle
////        let url = Bundle.main.url(forResource: "Lipsum", withExtension: "pdf")!
//        pdfDoc = PDFDocument(url: URL(string:"https://drive.google.com/file/d/1vyO230vt9uuDlyGaiTQ-s7jhtrWCN7QE/view?usp=sharing")!) ?? PDFDocument()
//    }
//
//    var body: some View {
//        VStack{
//            PDFKitView(showing: pdfDoc)
//
//
//        }
//    }
//}
//
//struct PDFKitView: UIViewRepresentable {
//
//    let pdfDocument: PDFDocument
//
//    init(showing pdfDoc: PDFDocument) {
//        self.pdfDocument = pdfDoc
//    }
//
//    //you could also have inits that take a URL or Data
//
//    func makeUIView(context: Context) -> PDFView {
//        let pdfView = PDFView()
//        pdfView.document = pdfDocument
//        pdfView.autoScales = true
//        return pdfView
//    }
//
//    func updateUIView(_ pdfView: PDFView, context: Context) {
//        pdfView.document = pdfDocument
//    }
//}
