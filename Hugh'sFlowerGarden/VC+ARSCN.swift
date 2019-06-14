//
//  VC+ARSCN.swift
//  Hugh'sFlowerGarden
//
//  Created by Mary Jiang on 6/13/19.
//  Copyright © 2019 Mary Jiang. All rights reserved.
//

import UIKit
import ARKit


extension ViewController : ARSKViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        
        print("Horizontal surface found")
        //let planeAnchor = anchor as! ARPlaneAnchor
        //let planeNode = createPlane(planeAnchor: planeAnchor)
        //planeNode.eulerAngles.x = GLKMathDegreesToRadians(-90)
        //node.addChildNode(planeNode)
        
        guard focusSquare == nil else {return}
        let focusSquareLocal = FocusSquare()
        self.sceneView.scene.rootNode.addChildNode(focusSquareLocal)
        self.focusSquare = focusSquareLocal
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        //let planeAnchor = anchor as! ARPlaneAnchor
        
        //remove plane anchor from scene
        //node.enumerateChildNodes { (childNode, _) in
        //    childNode.removeFromParentNode()
        //}
        
        //add plane back to scene by creating another plane
        //let planeNode = createPlane(planeAnchor: planeAnchor)
        //node.addChildNode(planeNode)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        
        //node.enumerateChildNodes{(childNode,_) in
        //    childNode.removeFromParentNode()
        //}
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let focusSquareLocal = focusSquare else {return}
        
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlane)
        let hitTestResult = hitTest.first //item closest to camera
        guard let worldTransform = hitTestResult?.worldTransform else {return}
        let worldTransformColumn3 = worldTransform.columns.3
        focusSquareLocal.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        DispatchQueue.main.async {self.updateFocusSquare()}
        
        
        
    }
    
    func createPlane(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        plane.firstMaterial?.diffuse.contents = UIImage(named:"grid")
        plane.firstMaterial?.isDoubleSided = true
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        return planeNode
        
    }
    
    
   
}
