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

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var boxButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var candleButton: UIButton!
    @IBOutlet weak var moonGateButton: UIButton!
    @IBOutlet weak var holeButton: UIButton!
    @IBOutlet weak var measureButton: UIButton!
    
    @IBOutlet weak var infoBgView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceBgView: UIView!
    
    var selectedScenePath : String?
    
    var screenCenter: CGPoint {
        let screenSize = view.bounds
        return CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.showsStatistics = true
        boxTapped(boxButton)
        distanceBgView.isHidden = true
        infoLabel.text = "All seems good :)"
        
        runSession()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cleanTapped(_ sender: Any) {
        removeChildren(inNode: sceneView.scene.rootNode)
        runSession()
    }
    
    @IBAction func holeTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/mini_portal.scn"
        selectButton(sender)
    }
    
    @IBAction func moonTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/moonGate.scn"
        selectButton(sender)
    }
    
    @IBAction func boxTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/box.scn"
        selectButton(sender)
    }
    
    @IBAction func lightTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/cloud.scn"
        selectButton(sender)
    }
    
    @IBAction func candleTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/candle.scn"
        selectButton(sender)
    }
    
    @IBAction func measureTapped(_ sender: UIButton) {
        selectedScenePath = ""
        selectButton(sender)
    }
    
    func selectButton (_ button: UIButton) {
        [holeButton, moonGateButton, boxButton, lightButton, candleButton, measureButton].forEach { (button) in
            button?.isSelected = false
            button?.layer.borderColor = UIColor.clear.cgColor
            button?.layer.borderWidth = 0
            distanceBgView.isHidden = true
        }
        
        button.isSelected = true
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 5
        
        if button.tag == 3 {
            distanceBgView.isHidden = false
        }
        
        print(selectedScenePath ?? "no obj selected")
    }
    
    func runSession() {
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [.horizontal, .vertical]
            
            guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
                print("ups, no ref images found...")
                return
            }
            configuration.detectionImages = referenceImages
            
        } else {
            configuration.planeDetection = .horizontal
        }
        
        
        
        configuration.isLightEstimationEnabled = true
        let options : ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        
        //deactivate if not needed!!
        //can have side effects on other features
//        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    }

}

extension ViewController : ARSCNViewDelegate {
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 1.50),
            .fadeOpacity(to: 0.15, duration: 1.50),
            .fadeOpacity(to: 0.85, duration: 1.50),
            .fadeOut(duration: 0.75),
            .removeFromParentNode()
            ])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let _ = anchor as? ARImageAnchor {
            //                let referenceImage = imageAnchor.referenceImage
            //                let plane = SCNPlane(width: referenceImage.physicalSize.width,
            //                                     height: referenceImage.physicalSize.height)
            //                let planeNode = SCNNode(geometry: plane)
            //                planeNode.opacity = 0.25
            //                planeNode.eulerAngles.x = -.pi / 2
            
            let phoneNode = SCNScene(named: "art.scnassets/box.scn")!.rootNode.clone()
            let rotationAction = SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1)
            let inifiniteAction = SCNAction.repeatForever(rotationAction)
            phoneNode.runAction(inifiniteAction)
            phoneNode.position = SCNVector3(anchor.transform.columns.3.x,anchor.transform.columns.3.y + 0.1,anchor.transform.columns.3.z)
            
            node.addChildNode(phoneNode)
        }
        
    }
    
    
}
