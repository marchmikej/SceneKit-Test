//
//  ViewController.swift
//  SceneKit Test
//
//  Created by Michael March on 3/7/16.
//  Copyright © 2016 Michael March. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    var sceneView: SCNView!
    var camera: SCNNode!
    var ground: SCNNode!
    var light: SCNNode!
    var button: SCNNode!
    var sphere1: SCNNode!
    var sphere2: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sceneView = SCNView(frame: self.view.frame)
        sceneView.scene = SCNScene()
        self.view.addSubview(sceneView)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: #selector(ViewController.sceneTapped(_:)))
        sceneView.gestureRecognizers = [tapRecognizer]
        
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.blue
        groundGeometry.materials = [groundMaterial]
        ground = SCNNode(geometry: groundGeometry)
        
        let camera = SCNCamera()
        camera.zFar = 10000
        self.camera = SCNNode()
        self.camera.camera = camera
        self.camera.position = SCNVector3(x: -20, y: 15, z: 50)
        let constraint = SCNLookAtConstraint(target: ground)
        constraint.isGimbalLockEnabled = true
        self.camera.constraints = [constraint]
        
        let ambientLight = SCNLight()
        ambientLight.color = UIColor.darkGray
        ambientLight.type = SCNLight.LightType.ambient
        self.camera.light = ambientLight
        
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.castsShadow = true
        spotLight.spotInnerAngle = 70.0
        spotLight.spotOuterAngle = 90.0
        spotLight.zFar = 500
        light = SCNNode()
        light.light = spotLight
        light.position = SCNVector3(x: 0, y: 25, z: 25)
        light.constraints = [constraint]
        
        let sphereGeometry = SCNSphere(radius: 1.5)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIColor.green
        sphereGeometry.materials = [sphereMaterial]
        sphere1 = SCNNode(geometry: sphereGeometry)
        sphere1.position = SCNVector3(x: -15, y: 1.5, z: 0)
        sphere2 = SCNNode(geometry: sphereGeometry)
        sphere2.position = SCNVector3(x: 15, y: 1.5, z: 0)
        
        let buttonGeometry = SCNBox(width: 4, height: 1, length: 4, chamferRadius: 0)
        let buttonMaterial = SCNMaterial()
        buttonMaterial.diffuse.contents = UIColor.red
        buttonGeometry.materials = [buttonMaterial]
        button = SCNNode(geometry: buttonGeometry)
        button.position = SCNVector3(x: 0, y: 0.5, z: 15)
        
        sceneView.scene?.rootNode.addChildNode(self.camera)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
        sceneView.scene?.rootNode.addChildNode(button)
        sceneView.scene?.rootNode.addChildNode(sphere1)
        sceneView.scene?.rootNode.addChildNode(sphere2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sceneTapped(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0] 
            let node = result.node
            
            if node == button {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                let materials = node.geometry!.materials
                let material = materials[0]
                material.diffuse.contents = UIColor.white
                SCNTransaction.commit()
                
                let action = SCNAction.moveBy(x: 0, y: -0.8, z: 0, duration: 0.5)
                node.runAction(action)
            }
        }
    }
    
}

