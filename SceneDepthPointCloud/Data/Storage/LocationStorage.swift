//
//  LocationStorage.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/05/29.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

/// 서버전송 오류로 인한 위치정보 임시저장소
final class LocationStorage {
    private init() { }
    
    static let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("locationData", isDirectory: false)
    
    static func save(_ obj: LocationData) -> Bool {
        print("---> save to here: \(url)")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(obj)
            //동일이름의 파일이 있는 경우 삭제
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            //파일을 저장
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            return true
        } catch let error {
            print("---> Failed to store msg: \(error.localizedDescription)")
            return false
        }
    }
    
    static func get() -> LocationData? {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let locationData = try decoder.decode(LocationData.self, from: data)
            return locationData
        } catch let error {
            print("---> Failed to decode msg: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func remove() {
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("---> Failed to remove msg: \(error.localizedDescription)")
        }
    }
}
