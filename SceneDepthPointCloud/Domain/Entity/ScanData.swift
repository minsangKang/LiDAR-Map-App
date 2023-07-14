//
//  ScanData.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/07/14.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

/// ScanStorage에 저장되는 스캔된 Point Cloud Data 정보
struct ScanData: Codable {
    let date: Date
    var fileName: String
    let lidarData: Data
    let lidarFileSize: String
    let points: Int
    
    
    init(rawStringData: String, pointCount: Int) {
        let now = Date()
        self.date = now
        self.fileName = "\(now.yyyyMMddHHmm).ply"
        guard let plyData = rawStringData.data(using: .utf8) else {
            self.lidarData = Data()
            self.lidarFileSize = "0 MB"
            self.points = 0
            return
        }
        
        self.lidarData = plyData
        self.lidarFileSize = plyData.fileSize
        self.points = pointCount
    }
    
    // MARK: Filename 변경
    mutating func rename(to name: String) {
        self.fileName = "\(name).ply"
    }
}
