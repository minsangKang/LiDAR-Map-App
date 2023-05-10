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
    
    // Create a SceneKit scene
    let scene = SCNScene()
    var fileContents: String?
    var points: [(Float, Float, Float, UInt32)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPCDFile()
        self.extractPoints()
    
        // Create a geometry representing a point in the PCD file
        let pointGeometry = SCNSphere(radius: 0.01) // adjust the radius as needed

        // Iterate through the points in the PCD file and add a node for each point
        for point in points {
            // Create a node for the point and set its position
            let pointNode = SCNNode(geometry: pointGeometry)
            pointNode.position = SCNVector3(point.0, point.1, point.2)

            // Set the color of the node based on the point's attributes (if applicable)
            let red = Int((point.3 >> 16) & 0xFF)
            let green = Int((point.3 >> 8) & 0xFF)
            let blue = Int(point.3 & 0xFF)
            let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
            pointNode.geometry?.firstMaterial?.diffuse.contents = color

            // Add the node to the scene
            self.scene.rootNode.addChildNode(pointNode)
        }
        self.points = []

        // Create a SceneKit view and add the scene to it
        let scnView = SCNView(frame: self.view.bounds)
        self.view.addSubview(scnView)
        scnView.scene = scene

        // Configure the view's camera
        let camera = SCNCamera()
        camera.zFar = 100 // adjust the zFar as needed
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 10) // adjust the position as needed
        scene.rootNode.addChildNode(cameraNode)
        
        // Allow user to manipulate camera
        scnView.allowsCameraControl = true
    }
}

extension PCDViewerVC {
    private func loadPCDFile() {
        // Load PCD file into a string
        guard let filePath = Bundle.main.path(forResource: "test", ofType: "pcd") else {
            print("Error loading PCD file")
            return
        }

        guard var fileContents = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            print("Error reading PCD file contents")
            return
        }
        self.fileContents = fileContents
    }
    
    private func extractPoints() {
        guard let fileContents = self.fileContents else { return }
        // Extract the points from the PCD file
        var headerFinded: Bool = false
        
        for line in fileContents.components(separatedBy: .newlines) {
            if headerFinded {
                // Extract the points from the PCD file
                let components = line.components(separatedBy: " ")
                if components.isEmpty == false, components.count == 4 {
                    let x = Float(components[0]) ?? 0
                    let y = Float(components[1]) ?? 0
                    let z = Float(components[2]) ?? 0
                    let color = UInt32(components[3]) ?? 0
                    self.points.append((x, y, z, color))
                }
                if points.count == 100000 {
                    break
                }
            } else {
                // Parse the header lines
                if line.hasPrefix("DATA ascii") {
                    headerFinded = true
                }
            }
        }
        
        self.fileContents = nil
    }
}
