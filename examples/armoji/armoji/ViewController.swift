//
//  ViewController.swift
//  myfirstapp
//
//  Created by Manu Rink on 01.06.20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var arview: ARSCNView!
    
    var latestSelectedEmoji = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runARSession()
    }
    
    func runARSession () {
        arview.delegate = self
        arview.showsStatistics = false
        arview.debugOptions = .showFeaturePoints
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        arview.session.run(configuration)
    }
    
    func createEmojiNode(for emoji: String, center: SCNVector3) -> SCNNode {
        let plane = SCNPlane(width: 0.05, height: 0.05)
        
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = emoji.image()!
        plane.materials = [planeMaterial]
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(center.x + 0.005, 0, 0)
        
        let lookAtConstraint = SCNBillboardConstraint()
        planeNode.constraints = [lookAtConstraint]
        
        //planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        return planeNode
    }
    
    func createText (for text : String) -> SCNNode {
        
        let text = SCNText(string: text, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white

        let textNode = SCNNode(geometry: text)

        let fontSize = Float(0.015)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        textNode.position = SCNVector3(0.045, 0, 0.02)
        
        let lookAtConstraint = SCNBillboardConstraint()
        textNode.constraints = [lookAtConstraint]
        
        return textNode
    }
    
    func createBubble () -> SCNNode {
        let bubblePlane = SCNPlane(width: 0.07, height: 0.07)
        
        let bubbleMaterial = SCNMaterial()
        bubbleMaterial.diffuse.contents = UIImage(named: "comment_trans")
        bubblePlane.materials = [bubbleMaterial]
        let bubbleNode = SCNNode(geometry: bubblePlane)
        bubbleNode.position = SCNVector3(0, 0, -0.005)
        
        let lookAtConstraint = SCNBillboardConstraint()
        bubbleNode.constraints = [lookAtConstraint]
        
        return bubbleNode
    }
    
    @IBAction func emojiButtonTapped(_ sender: Any) {
        
        let button = sender as! UIButton
        latestSelectedEmoji = button.title(for: .normal)!
        
        let loc = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        let hits = arview.hitTest(loc, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
        
        if let hit = hits.first {
            arview.session.add(anchor: ARAnchor(transform: hit.worldTransform))
        }
        
        switch latestSelectedEmoji {
        case "☀️" : helloLabel.text = "Hello Sunshine!"
            case "😡" : helloLabel.text = "Hello Grumpy!"
            case "😍" : helloLabel.text = "Hello Love!"
            case "🍔" : helloLabel.text = "Hello Hungry!"
            case "🏳️‍🌈" : helloLabel.text = "Hello Equally Loved!"
            case "💪" : helloLabel.text = "Hello Muscle!"
            default : break
        }
    }

}



extension ViewController : ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            let emoji = createEmojiNode(for: latestSelectedEmoji,
                center: node.position)
            
            let bubble = createBubble()
            
            node.addChildNode(emoji)
            node.addChildNode(bubble)
            
            /*DispatchQueue.main.async {
                let text = self.createText(for: self.helloLabel.text!)
                node.addChildNode(text)
            }*/
        }
        
    }
}

extension String {

    func image() -> UIImage? {
        let size = CGSize(width: 35, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
