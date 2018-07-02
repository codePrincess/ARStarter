//
//  ViewController.swift
//  AREasyStart
//
//  Created by Manuela Rink on 01.06.18.
//  Copyright © 2018 Manuela Rink. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GameplayKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var sunshineSystem : SCNParticleSystem?
    var timer : Timer?
    var flowers : [SCNNode] = []
    
    var screenCenter: CGPoint {
        let screenSize = view.bounds
        return CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        runSession()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func runSession() {
        
    }
    
    func doFlowerPlanting (_ node: SCNNode) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { timer in
            DispatchQueue.main.async {
                if let sun = self.sunshineSystem, sun.particleIntensity > 0.5 {
                    var positionX = Float(GKRandomSource.sharedRandom().nextInt(upperBound: 10)) / 100
                    positionX = positionX < 0.05 ? positionX * -1 : positionX
                    var positionZ = Float(GKRandomSource.sharedRandom().nextInt(upperBound: 10)) / 100
                    positionZ = positionZ < 0.05 ? positionZ * -1 : positionZ
                    
                    let flower = SCNScene(named: "art.scnassets/flower.scn")!
                    let flowerNode = flower.rootNode.childNode(withName: "flower", recursively: true)!
                    
                    var flowerSizeFactor : CGFloat = 1.0
                    if let frame = self.sceneView.session.currentFrame {
                        flowerSizeFactor = (frame.lightEstimate?.ambientIntensity)! / 1000.0
                    }
                    
                    flowerNode.scale = SCNVector3(flowerSizeFactor-0.5, flowerSizeFactor-0.5, flowerSizeFactor-0.5)
                    flowerNode.position = SCNVector3Make(node.position.x + positionX,
                                                         -0.02,
                                                         node.position.z + positionZ)
                    self.flowers.append(flowerNode)
                    node.addChildNode(flowerNode)
                }
            }
        })
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

    }

}

//extension ViewController : ARSCNViewDelegate {
//
//    var imageHighlightAction: SCNAction {
//        return .sequence([
//            .wait(duration: 0.25),
//            .fadeOpacity(to: 0.85, duration: 1.50),
//            .fadeOpacity(to: 0.15, duration: 1.50),
//            .fadeOpacity(to: 0.85, duration: 1.50),
//            .fadeOut(duration: 0.75),
//            .removeFromParentNode()
//            ])
//    }
//
//
//
//
//}
