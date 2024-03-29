//
//  CancelButton.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/04/21.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

/// SelectLocationVC의 우상단 취소버튼 커스텀뷰
final class CancelButton: UIButton {
    convenience init() {
        self.init(frame: CGRect())
        self.configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage.init(systemName: "xmark"), for: .normal)
        self.setPreferredSymbolConfiguration(.init(pointSize: 18, weight: .regular, scale: .large), forImageIn: .normal)
        self.tintColor = .white
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 22),
            self.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
