//
//  SelectLocationLargeButton.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/04/21.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

/// SelectLocationVC 중앙하단 버튼
final class SelectLocationLargeButton: UIButton {
    enum Status {
        case selectable
        case beforeSetting
        case settingChanged
        case uploadable
    }
    
    convenience init() {
        self.init(frame: CGRect())
        self.configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.backgroundColor = UIColor(named: "mainColor")
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.titleLabel?.textColor = .white
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.changeStatus(to: .selectable)
    }
    
    /// Status 값에 따라 버튼의 텍스트 설정하는 함수
    func changeStatus(to status: Status) {
        switch status {
        case .selectable:
            self.setTitle("선택 완료", for: .normal)
            self.isUserInteractionEnabled = true
            self.backgroundColor = UIColor(named: "mainColor")
        case .beforeSetting:
            self.setTitle("설정 완료", for: .normal)
            self.isUserInteractionEnabled = false
            self.backgroundColor = UIColor(named: "deActivateMainColor")
        case .settingChanged:
            self.setTitle("설정 완료", for: .normal)
            self.isUserInteractionEnabled = true
            self.backgroundColor = UIColor(named: "mainColor")
        case .uploadable:
            self.setTitle("데이터 업로드", for: .normal)
            self.isUserInteractionEnabled = true
            self.backgroundColor = UIColor(named: "mainColor")
        }
    }
}
