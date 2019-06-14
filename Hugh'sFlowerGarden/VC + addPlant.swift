//
//  VC + addPlant.swift
//  Hugh'sFlowerGarden
//
//  Created by Mary Jiang on 6/13/19.
//  Copyright © 2019 Mary Jiang. All rights reserved.


import UIKit
import SceneKit
import ARKit

extension ViewController {
    

    
    fileprivate func getModel(named name: String) -> SCNNode? {
        let scene = SCNScene(named: "art.scnassets/\(name)/\(name).scn")!
        guard let model = scene.rootNode.childNode(withName: "model", recursively: false) else {return nil}
        model.name = name
        return model
    }
    
    @IBAction func bushstonesButtonTapped(_ sender: Any) {
        modelToAdd = "gardenflower"
        plantNameLabel.text = modelToAdd

    }
    @IBAction func lilyButtonTapped(_ sender: Any) {
        modelToAdd = "lily"
        plantNameLabel.text = modelToAdd
    }
    
    @IBAction func lavenderButtonTapped(_ sender: Any) {
        modelToAdd = "lavender"
        plantNameLabel.text = modelToAdd
    }
    
    @objc func addPlantToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        let modelName = modelToAdd
        guard let model = getModel(named: modelName) else {
            print("Unable to load \(String(describing: modelName)) from file")
            return
        }
        
        guard let worldTransformColumn3 = hitTestResults.first?.worldTransform.columns.3 else {return}
        model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        sceneView.scene.rootNode.addChildNode(model)
        print("\(String(describing: modelName)) added successfully")
        
    }

  
    

}

