//
//  ModelViewModel.swift
//  stor3D
//
//  Created by Tunay Toksöz on 28.12.2022.
//

import Foundation

class ModelViewModel{
    
    func downloadUsdzModel(url: String, completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void) {
        
        let itemUrl = URL(string: url)
        
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("model.usdz")
        
        try? FileManager.default.removeItem(at: destinationUrl)
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
            
        } else {
            
            URLSession.shared.downloadTask(with: itemUrl!, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    print("File moved to documents folder")
                    completion(true, destinationUrl)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }).resume()
        }
    }
}
