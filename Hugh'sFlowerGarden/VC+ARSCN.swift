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
        
        //print("Horizontal surface found")
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
    
    func addAnimation(node: SCNNode) {
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.05, z: 0, duration: 2.5)
        let rotateLeft = SCNAction.rotateBy(x: -0.2, y: -0.2, z: 0, duration: 2)
        let rotateRight = SCNAction.rotateBy(x: 0.2, y: 0.2, z: 0, duration: 2)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.05, z: 0, duration: 2.5)
        //let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let one = SCNAction.sequence([hoverUp, rotateLeft])
        let two = SCNAction.group([one, rotateRight])
        let final = SCNAction.group([two,hoverDown])
        //let rotateAndHover = SCNAction.group([rotateOne, hoverSequence])
        let repeatForever = SCNAction.repeatForever(final)
        node.runAction(repeatForever)
    }
    
    func flowerLabel(node: SCNNode, labelname: String) {
        let plane = SCNNode(geometry: SCNPlane(width: 0.2,
                                               height: 0.1))
        plane.geometry?.firstMaterial?.diffuse.contents = UIImage(named: labelname)
        plane.geometry?.firstMaterial?.isDoubleSided = true
        plane.position = node.position
        plane.position.y = node.position.y+0.6
        plane.position.z = node.position.z+0.1
        sceneView.scene.rootNode.addChildNode(plane)
    }

    
    func addLabel(node: SCNNode){
        switch node.name{
        case "lily":
            flowerLabel(node: node, labelname: "lily_label")
        case "gardenflower":
            flowerLabel(node: node, labelname: "flower_label")
        case "lavender":
            flowerLabel(node: node, labelname: "bush_label")
        default:
                flowerLabel(node: node, labelname: "lily_label")
        }
        
        
    }
    
    @objc func getPlantInfo(withGestureRecognizer gestureRecognizer: UILongPressGestureRecognizer){
        guard gestureRecognizer.state == .ended else{return}
        let taplocation = gestureRecognizer.location(in: sceneView)
        let hittestreults = sceneView.hitTest(taplocation,options: [:])
        guard let hitTestResult = hittestreults.first else { return }
        let finalnode = hitTestResult.node
        addLabel(node: finalnode)
        addAnimation(node: finalnode)
    }
    
    /*
    
    func showPlantDetail(plantName: String){
        
    }
    */
    
   
}

