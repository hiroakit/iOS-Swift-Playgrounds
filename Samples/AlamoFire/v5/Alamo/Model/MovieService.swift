//
//  MovieService.swift
//  Alamo
//
//  Created by hiroakit on 2025/03/09.
//


import Foundation
import Alamofire

class MovieService {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func uploadFiles(_ items: [URL], completion: @escaping (Bool, Int?) -> Void) {
        let baseUrl = networkManager.getApiBaseUrl()
        let uploadURL = "\(baseUrl)/api/v1/movie"
        
        var files: [(String, Data, String)] = []
        
        for (index, url) in items.enumerated() {
            if let data = try? Data(contentsOf: url) {
                files.append(("file\(index + 1).mp4", data, "video/mp4"))
            }
        }

        networkManager.session.upload(multipartFormData: { multipartFormData in
            for file in files {
                multipartFormData.append(file.1, withName: "files", fileName: file.0, mimeType: file.2)
            }
        }, to: uploadURL, method: .post)
        .response { response in
            switch response.result {
            case .success:
                // HTTP ステータスコードを取得
                if let statusCode = response.response?.statusCode {
                    if (200...299).contains(statusCode) {
                        print("Upload successful: HTTP \(statusCode)")
                        completion(true, statusCode)
                    } else {
                        print("Upload failed with status code: HTTP \(statusCode)")
                        completion(false, statusCode)
                    }
                } else {
                    print("Upload failed: No HTTP response")
                    completion(false, nil)
                }                
            case .failure(let error):
                print("Upload request failed: \(error.localizedDescription)")
                let statusCode = response.response?.statusCode
                completion(false, statusCode)
            }
        }
    }

}
