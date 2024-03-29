//
//  KakaoApiService.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/04/24.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

/// Building 정보를 수신받기 위한 Network Service 담당
struct KakaoApiService {
    /// KakaoAPI를 통해 BuildingNearByGpsDTO를 반환하는 함수
    func getSearchByCategory(x: Double, y: Double, page: Int, completion: @escaping (Result<BuildingNearByGpsDTO, FetchError>) -> Void) {
        var parameters: [String: Any] = ["x": x, "y": y, "page": page]
        // KakaoAPI에 필요한 추가 parameter들 (고정값들)
        parameters["radius"] = 100 // 100m로 고정
        parameters["sort"] = "distance" // 거리값 기준 정렬로 고정
        parameters["category_group_code"] = " " // 모든 카테고리 값으로 고정
        
        Network.request(url: NetworkURL.Kakao.searchByCategory, method: .get, parameters: parameters) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data else {
                    completion(.failure(.empty))
                    return
                }
                
                guard let dto = try? JSONDecoder().decode(BuildingNearByGpsDTO.self, from: data) else {
                    completion(.failure(.decode))
                    return
                }
                
                completion(.success(dto))
                
            case .ERROR(let statusCode):
                completion(.failure(.server(statusCode)))
            }
        }
    }
    
    /// KakaoAPI를 통해 AddressFromGpsDTO를 반환하는 함수
    func getCoordToAddress(x: Double, y: Double, completion: @escaping (Result<AddressFromGpsDTO, FetchError>) -> Void) {
        let parameters = ["x": x, "y": y]
        
        Network.request(url: NetworkURL.Kakao.coordToAddress, method: .get, parameters: parameters) { result in
            switch result.status {
            case .SUCCESS:
                guard let data = result.data else {
                    completion(.failure(.empty))
                    return
                }
                
                guard let dto = try? JSONDecoder().decode(AddressFromGpsDTO.self, from: data) else {
                    completion(.failure(.decode))
                    return
                }
                
                completion(.success(dto))
                
            case .ERROR(let statusCode):
                completion(.failure(.server(statusCode)))
            }
        }
    }
}
