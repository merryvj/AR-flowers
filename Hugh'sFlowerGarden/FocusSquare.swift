//
//  FocusSquare.swift
//  Hugh'sFlowerGarden
//
//  Created by Mary Jiang on 6/13/19.
//  Copyright © 2019 Mary Jiang. All rights reserved.
//
import SceneKit
import ARKit

class FocusSquare: SCNNode{
    
    var focusSquare: FocusSquare?
    
    override init(){
        super.init()
        let plane = SCNPlane(width: 0.1, height: 0.1)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "close")
        plane.firstMaterial?.isDoubleSided = true
        
        geometry = plane
        eulerAngles.x = GLKMathDegreesToRadians(-90)
    }
    
    var isClosed : Bool = true {
        didSet {
            geometry?.firstMaterial?.diffuse.contents = self.isClosed ? UIImage(named: "close") : UIImage(named: "open")
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
