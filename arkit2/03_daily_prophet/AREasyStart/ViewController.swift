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
    
    var avPlayers : [String : AVPlayer] = [:]
    var imageNodes : [SCNNode] = []
    
    var screenCenter: CGPoint {
        let screenSize = view.bounds
        return CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    }
    
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            self.avPlayers.forEach { key, value in
                if notification.description.contains(key) {
                    value.seek(to: CMTime.zero)
                    value.play()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        runSession()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func runSession() {
        
        let configuration = ARImageTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "trackingimages", bundle: nil) else {
            return
        }
        
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 5
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        updateQueue.async {
            if let _ = anchor as? ARImageAnchor {
                if renderer.isNode(node, insideFrustumOf: self.sceneView.pointOfView!) && node.opacity == 0 {
                    if node.opacity == 0 {
                        node.runAction(SCNAction.fadeOpacity(to: 1, duration: 1.5))
                    }
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updateQueue.async {
            self.imageNodes.forEach { node in
                if !renderer.isNode(node, insideFrustumOf: self.sceneView.pointOfView!) {
                    node.runAction(SCNAction.fadeOpacity(to: 0, duration: 1.5))
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let imageName = imageAnchor.referenceImage.name
            
            guard let path = Bundle.main.path(forResource: imageName!, ofType: "mp4") else {
                return
            }
            
            let videoURL = URL(fileURLWithPath: path)
            let avPlayerItem = AVPlayerItem(url: videoURL)
            let avPlayer = AVPlayer(playerItem: avPlayerItem)
            avPlayer.play()
            avPlayers[imageName!] = avPlayer
            
            updateQueue.async {
                node.opacity = 0
                
                let avMaterial = SCNMaterial()
                avMaterial.diffuse.contents = avPlayer
                
                let videoPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                     height: imageAnchor.referenceImage.physicalSize.height)
                videoPlane.materials = [avMaterial]
                
                
                let videoNode = SCNNode(geometry: videoPlane)
                videoNode.name = "videonode"
                videoNode.eulerAngles.x = -.pi / 2
                
                let colorMaterial = SCNMaterial()
                colorMaterial.diffuse.contents = UIColor(red: 202/255, green: 133/255, blue: 88/255, alpha: 0.3)
                let coverPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                     height: imageAnchor.referenceImage.physicalSize.height)
                coverPlane.materials = [colorMaterial]
                
                let coverNode = SCNNode(geometry: coverPlane)
                coverNode.name = "covernode"
                coverNode.eulerAngles.x = -.pi / 2
                
                node.addChildNode(videoNode)
                node.addChildNode(coverNode)
                
                node.runAction(SCNAction.fadeOpacity(to: 1, duration: 1.5))
                
                self.imageNodes.append(node)
            }
            
        }
        
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
