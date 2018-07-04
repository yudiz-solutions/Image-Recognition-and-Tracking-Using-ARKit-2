//
//  ViewController.swift
//  ImageDetectionUsingARKit
//
//  Created by Yudiz on 25/06/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

/// ViewController
class ViewController: UIViewController {
    
    /// IBOutlet(s)
    @IBOutlet var sceneView: ARSCNView!
    
    /// Variable Declaration(s)
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureARImageTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - UI Related Method(s)
extension ViewController {
    
    func prepareUI() {    
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    func configureARImageTracking() {
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        if let imageTrackingReference = ARReferenceImage.referenceImages(inGroupNamed: "iOSDept", bundle: Bundle.main) {
            configuration.trackingImages = imageTrackingReference
            configuration.maximumNumberOfTrackedImages = 1
        } else {
            print("Error: Failed to get image tracking referencing image from bundle")
        }
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - UIButton Action(s)
extension ViewController {
    
    @IBAction func tapBtnRefresh(_ sender: UIButton) {
        configureARImageTracking()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        /// Casting down ARAnchor to `ARImageAnchor`.
        if let imageAnchor =  anchor as? ARImageAnchor {
            let imageSize = imageAnchor.referenceImage.physicalSize
            
            let plane = SCNPlane(width: CGFloat(imageSize.width), height: CGFloat(imageSize.height))
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let imageHightingAnimationNode = SCNNode(geometry: plane)
            imageHightingAnimationNode.eulerAngles.x = -.pi / 2
            imageHightingAnimationNode.opacity = 0.25
            node.addChildNode(imageHightingAnimationNode)
            
            imageHightingAnimationNode.runAction(imageHighlightAction) {
                // About
                let aboutSpriteKitScene = SKScene(fileNamed: "About")
                aboutSpriteKitScene?.isPaused = false
                
                let aboutUsPlane = SCNPlane(width: CGFloat(imageSize.width * 1.5), height: CGFloat(imageSize.height * 1.2))
                aboutUsPlane.firstMaterial?.diffuse.contents = aboutSpriteKitScene
                aboutUsPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                
                let aboutUsNode = SCNNode(geometry: aboutUsPlane)
                aboutUsNode.geometry?.firstMaterial?.isDoubleSided = true
                aboutUsNode.eulerAngles.x = -.pi / 2
                aboutUsNode.position = SCNVector3Zero
                node.addChildNode(aboutUsNode)
                
                let moveAction = SCNAction.move(by: SCNVector3(0.25, 0, 0), duration: 0.8)
                aboutUsNode.runAction(moveAction, completionHandler: {
                    let titleNode = aboutSpriteKitScene?.childNode(withName: "TitleNode")
                    titleNode?.run(SKAction.moveTo(y: 90, duration: 1.0))
                    
                    let name = aboutSpriteKitScene?.childNode(withName: "DescriptionNode")
                    name?.run(SKAction.moveTo(y: -30, duration: 1.0))
                    
                    // Logo Related
                    let logoScene = SCNScene(named: "art.scnassets/Yudiz_3D_Logo.dae")!
                    let logoNode = logoScene.rootNode.childNodes.first!
                    logoNode.scale = SCNVector3(0.022, 0.022, 0.022)
                    logoNode.eulerAngles.x = -.pi / 2
                    logoNode.position = SCNVector3Zero
                    logoNode.position.z = 0.05
                    let rotationAction = SCNAction.rotateBy(x: 0, y: 0, z: 0.5, duration: 1)
                    let inifiniteAction = SCNAction.repeatForever(rotationAction)
                    logoNode.runAction(inifiniteAction)
                    node.addChildNode(logoNode)
                    
                    // What We Do
                    let whatWeDoSpriteKitScene = SKScene(fileNamed: "WhatWeDo")
                    whatWeDoSpriteKitScene?.isPaused = false
                    
                    let whatWeDoPlane = SCNPlane(width: CGFloat(imageSize.width * 1.5), height: CGFloat(imageSize.height * 1.2))
                    whatWeDoPlane.firstMaterial?.diffuse.contents = whatWeDoSpriteKitScene
                    whatWeDoPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                    
                    let whatWeDoNode = SCNNode(geometry: whatWeDoPlane)
                    whatWeDoNode.geometry?.firstMaterial?.isDoubleSided = true
                    whatWeDoNode.eulerAngles.x = -.pi / 2
                    whatWeDoNode.position = SCNVector3Zero
                    node.addChildNode(whatWeDoNode)
                    
                    let move1Action = SCNAction.move(by: SCNVector3(-0.25, 0, 0), duration: 0.8)
                    whatWeDoNode.runAction(move1Action, completionHandler: {
                        let titleNode = whatWeDoSpriteKitScene?.childNode(withName: "TitleNode")
                        
                        let dept1 = whatWeDoSpriteKitScene?.childNode(withName: "Dept1Node")
                        dept1?.run(SKAction.fadeOut(withDuration: 0.0))
                        
                        let dept2 = whatWeDoSpriteKitScene?.childNode(withName: "Dept2Node")
                        dept2?.run(SKAction.fadeOut(withDuration: 0.0))

                        titleNode?.run(SKAction.moveTo(x: 0, duration: 1.0), completion: {
                            dept1?.run(SKAction.moveTo(y: 30, duration: 0.8))
                            dept1?.run(SKAction.fadeIn(withDuration: 1.0), completion: {
                                dept2?.run(SKAction.moveTo(y: -80, duration: 0.8))
                                dept2?.run(SKAction.fadeIn(withDuration: 1.0))
                            })
                        })
                        
                    })
                })
            }
        } else {
            print("Error: Failed to get ARImageAnchor")
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Error didFailWithError: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("Error sessionWasInterrupted: \(session.debugDescription)")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("Error sessionInterruptionEnded : \(session.debugDescription)")
    }
}
