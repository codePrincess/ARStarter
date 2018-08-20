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
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "trackimages", bundle: nil) else {
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
            
            if imageName == "wetter" {
                let weather = SCNScene(named: "art.scnassets/wetter.scn")?.rootNode
                node.addChildNode(weather!)
                return
            }
            else if imageName == "drogen" {
                let diagram = SCNScene(named: "art.scnassets/diagram.scn")?.rootNode
                node.addChildNode(diagram!)
                return
            }
            
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
                
                let playerWidth = imageAnchor.referenceImage.physicalSize.width
                let playerHeight = playerWidth / 16 * 9
                let videoPlane = SCNPlane(
                    width: playerWidth,
                    height: playerHeight)
                videoPlane.materials = [avMaterial]
                
                
                let videoNode = SCNNode(geometry: videoPlane)
                videoNode.name = "videonode"
                videoNode.position.x += videoNode.position.x*0.125
                videoNode.position.y += videoNode.position.y*0.125
                videoNode.eulerAngles.x = -.pi / 2
                
                let whiteBorderMaterial = SCNMaterial()
//                whiteBorderMaterial.diffuse.contents = UIColor(red: 216/255, green: 212/255, blue: 203/255, alpha: 0.75)
                whiteBorderMaterial.diffuse.contents = UIColor(white: 0, alpha: 0.8)
                let whiteBorderPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width*1.03,
                                          height: imageAnchor.referenceImage.physicalSize.height*1.03)
                whiteBorderPlane.materials = [whiteBorderMaterial]
                
                let whiteBorderNode = SCNNode(geometry: whiteBorderPlane)
                whiteBorderNode.name = "whitebordernode"
                whiteBorderNode.eulerAngles.x = -.pi / 2
                
                node.addChildNode(whiteBorderNode)
                videoNode.position.y += 0.005
                node.addChildNode(videoNode)
                
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
