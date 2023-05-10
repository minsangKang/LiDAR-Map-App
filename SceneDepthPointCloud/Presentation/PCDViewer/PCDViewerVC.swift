//
//  PCDViewerVC.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/05/10.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit
import SceneKit

final class PCDViewerVC: UIViewController {
    static let identifier = "PCDViewerVC"
    
    // Create a SceneKit Scene
    let scene = SCNScene()
    
    // Create a Point Cloud Node
    let pointCloudNode = SCNNode()
    
    // Create LightNode
    let lightNode = SCNNode()
    
    // Create AmbientLightNode
    let ambientLightNode = SCNNode()
    
    // Create a Geometry
    var pointCloudGeometry = SCNGeometry()
    
    // Add Point Cloud Data to Geometry
    var pointCloudData: [SCNVector3] = []
    
    let sceneView = SCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPcdData()
        self.configurePointCloudGeometry()
        self.configureCamera()
        self.configureLight()
        self.configureSCNView()
    }
    
}

extension PCDViewerVC {
    private func loadPcdData() {
        guard let filePath = Bundle.main.path(forResource: "test2", ofType: "pcd") else {
            fatalError("Unable to find the file test.pcd")
        }

        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            self.pointCloudData = self.parsePointCloudData(from: fileContents)
        } catch {
            fatalError("Unable to read the contents of the file test.pcd")
        }

    }
    
    private func parsePointCloudData(from fileContents: String) -> [SCNVector3] {
        var pointCloudData = [SCNVector3]()
        
        let lines = fileContents.components(separatedBy: .newlines)
        var isDataSection = false
        
        for line in lines {
            if line.hasPrefix("DATA") {
                isDataSection = true
                continue
            }
            
            if isDataSection {
                let components = line.components(separatedBy: " ")
                if components.count >= 3,
                   let x = Float(components[0]),
                   let y = Float(components[1]),
                   let z = Float(components[2])
                {
                    let point = SCNVector3(x, y, z)
                    pointCloudData.append(point)
                }
            }
        }
        
        return pointCloudData
    }
    
    private func configurePointCloudGeometry() {
        guard self.pointCloudData.isEmpty == false else { return }
        let vertices = self.pointCloudData.compactMap { SCNVector3($0.x, $0.y, $0.z) }
        let vertexSource = SCNGeometrySource(normals: vertices)
//        self.pointCloudGeometry.
        self.pointCloudGeometry = SCNGeometry(sources: [vertexSource], elements: nil)
        
        // Set Geometry Material
        let pointCloudMaterial = SCNMaterial()
        self.pointCloudGeometry.materials = [pointCloudMaterial]
        
        // Add Geometry to Point Cloud Node
        self.pointCloudNode.geometry = self.pointCloudGeometry
        
//        // Add Point Cloud Node to Scene
//        self.scene.rootNode.addChildNode(self.pointCloudNode)
    }
    
    private func configureCamera() {
        // Add camera node
        self.pointCloudNode.camera = SCNCamera()
        // Place camera
        self.pointCloudNode.position = SCNVector3(x: 0, y: 10, z: 35)
        // Set camera on scene
        self.scene.rootNode.addChildNode(self.pointCloudNode)
    }
    
    private func configureLight() {
        // Adding light to scene
        self.lightNode.light = SCNLight()
        self.lightNode.light?.type = .omni
        self.lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        self.scene.rootNode.addChildNode(self.lightNode)
    }
    
    private func configureAmbientLight() {
        // 6: Creating and adding ambien light to scene
        self.ambientLightNode.light = SCNLight()
        self.ambientLightNode.light?.type = .ambient
        self.ambientLightNode.light?.color = UIColor.darkGray
        self.scene.rootNode.addChildNode(self.ambientLightNode)
    }
    
    private func configureSCNView() {
        // Create a Scene View and present the scene
        self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.backgroundColor = .black
        
        // Add the scene view to your view hierarchy
        self.view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            self.sceneView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.sceneView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.sceneView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.sceneView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Allow user to manipulate camera
        self.sceneView.allowsCameraControl = true
        // Allow user translate image
        self.sceneView.cameraControlConfiguration.allowsTranslation = false
        // Set scene settings
        self.sceneView.scene = self.scene
    }
}
