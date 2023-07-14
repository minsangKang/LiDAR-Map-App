//
//  ScanStorage.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/07/14.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

/// 스캔된 Point Cloud Data 저장소
final class ScanStorage {
    private init() { }
    static let shared = ScanStorage()
    
    static let rootUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("scans", isDirectory: false)
    
    static var infos: [ScanInfo] {
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: rootUrl.path)
            var infos: [ScanInfo] = []
            for item in items {
                print(item)
                if let info = get(fileName: item)?.info {
                    infos.append(info)
                }
            }
            return infos
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func save(_ obj: ScanData) -> Bool {
        let url = rootUrl.appendingPathComponent(obj.fileName)
        print("---> save to here: \(url.path)")
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
    
    static func get(fileName: String) -> ScanData? {
        let url = rootUrl.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let scanData = try decoder.decode(ScanData.self, from: data)
            return scanData
        } catch let error {
            print("---> Failed to decode msg: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func remove(fileName: String) {
        do {
            let url = rootUrl.appendingPathComponent(fileName)
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("---> Failed to remove msg: \(error.localizedDescription)")
        }
    }
}
