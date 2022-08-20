//
//  FileManagerPracticeView2.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/03.
//

import SwiftUI

struct FileManagerPracticeView2: View {
    
    
    var body: some View {
        VStack{
            
        }
    }
}

struct FileManagerPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerPracticeView2()
    }
}

//MARK: - File Mangement Common functions libraries
struct CustomFileManager {
    static let homeDirURL = URL(fileURLWithPath: NSHomeDirectory());
    static let path = homeDirURL.relativePath
    static let manageFolder =  ".xxxxxxx"
    static let myFilePath = path + "/" + manageFolder
    static let folderSeperator = "_"


    // Get all folder list
    static func getFolderList() -> [String]? {
        let fm = FileManager.default

        do {
            if !fm.fileExists(atPath: myFilePath) {
                
                // 폴더가 없으면 하나 만들기
                let nestedFolderURL = homeDirURL.appendingPathComponent(manageFolder)
                
                try fm.createDirectory(
                    at: nestedFolderURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            }
            print("myfilePath \(myFilePath)")
            // 폴더 내 파일 접근
            let items = try fm.contentsOfDirectory(atPath: myFilePath)
            print("path \(items)")
            return items
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // Create new Folder
    static func createFolder(_ name: String) -> Int {
        let fm = FileManager.default
        // UUID().uuidString
        let folderName = name
        
        do {
            let url = URL(fileURLWithPath: myFilePath)
            let nestedFolderURL = url.appendingPathComponent(folderName)
            
            // folder가 이미 존재하는지 체크하기
            if !fm.fileExists(atPath: myFilePath + "/" + folderName) {
                
                try fm.createDirectory(
                    at: nestedFolderURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
                
                return 1
            } else {
                return 2
            }
            
        } catch {
            print(error)
            return 0
        }
        
    }
    
    // Get all file list from a given folder path
    static func getFileList(_ folderName: String) -> [String]? {
        let fm = FileManager.default
        let fullFilePath = myFilePath + "/" + folderName

        do {
           
            print("fullFilePath \(fullFilePath)")
            let items = try fm.contentsOfDirectory(atPath: fullFilePath)
            print("fullFilePath items \(items)")
            return items
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
