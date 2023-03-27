//
//  MainApiService.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/03/27.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

final class MainApiService {
    /// ply 데이터를 서버로 전송
    func uploadPlyData(fileName: String, fileData: Data, completion: @escaping (NetworkResult) -> Void) {
        Network.uploadData(url: NetworkURL.uploadPly, fileName: fileName, fileData: fileData) { result in
            completion(result)
        }
    }
}
