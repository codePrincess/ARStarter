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
    
    @IBOutlet weak var boxButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var candleButton: UIButton!
    @IBOutlet weak var measureButton: UIButton!
    
    @IBOutlet weak var infoBgView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var selectedScenePath : String?
    
    var screenCenter: CGPoint {
        let screenSize = view.bounds
        return CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.showsStatistics = true
        boxTapped(boxButton)
        infoBgView.isHidden = true
        distanceLabel.isHidden = true
        
        runSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func boxTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/box.scn"
        selectButton(sender)
    }
    
    @IBAction func lightTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/lamp.scn"
        selectButton(sender)
    }
    
    @IBAction func candleTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/candle.scn"
        selectButton(sender)
    }
    
    @IBAction func measureTapped(_ sender: UIButton) {
        selectButton(sender)
    }
    
    func selectButton (_ button: UIButton) {
        [boxButton, lightButton, candleButton, measureButton].forEach { (button) in
            button?.isSelected = false
            button?.layer.borderColor = UIColor.clear.cgColor
            button?.layer.borderWidth = 0
            distanceLabel.isHidden = true
        }
        
        button.isSelected = true
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 5
        
        if button.tag == 3 {
            distanceLabel.isHidden = false
        }
        
        print(selectedScenePath ?? "no obj selected")
    }
    
    func runSession() {
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
        
        //deactivate if not needed!!
        //can have side effects on other features
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let hit = sceneView.hitTest(screenCenter, types: [.existingPlaneUsingExtent]).first {
            sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
            return
        } else if let hit = sceneView.hitTest(screenCenter, types: [.featurePoint]).last {
            sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
            return
        }
    }
}

extension ViewController : ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let planeNode = createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
                node.addChildNode(planeNode)
            } else if let path = self.selectedScenePath {
                let modelClone = SCNScene(named: path)!.rootNode.clone()
                node.addChildNode(modelClone)
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                updatePlaneNode(node.childNodes[0], center: planeAnchor.center, extent: planeAnchor.extent)
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        removeChildren(inNode: node)
        
    }

}
