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
    
    let omniLight = SCNLight()
    let ambientLight = SCNLight()
    var currentLightEstimate : ARLightEstimate?
    
    var measuringNodes: [SCNNode] = []
    
    var selectedScenePath : String?
    
    var screenCenter: CGPoint {
        let screenSize = view.bounds
        return CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.showsStatistics = true
        boxTapped(boxButton)
        distanceBgView.isHidden = true
        infoLabel.text = "All seems good :)"
        
        runSession()
        addLightToScene()
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
    
    @IBAction func cleanTapped(_ sender: Any) {
        removeChildren(inNode: sceneView.scene.rootNode)
        addLightToScene()
    }
    
    @IBAction func holeTapped(_ sender: UIButton) {
        selectedScenePath = "art.scnassets/hole.scn"
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
    
    func addLightToScene () {
        omniLight.type = .directional
        omniLight.name = "omniLight"
        omniLight.castsShadow = true
        omniLight.shadowMode = .deferred
        omniLight.forcesBackFaceCasters = true
        omniLight.shadowSampleCount = 20
        omniLight.shadowColor = UIColor(white: 0, alpha: 0.5)
        
        let spotNode = SCNNode()
        spotNode.light = omniLight
        spotNode.position = SCNVector3Make(0, 50, 0)
        spotNode.eulerAngles = SCNVector3Make(-.pi/2, 0, 0)
        sceneView.scene.rootNode.addChildNode(spotNode)
        
        ambientLight.type = .ambient
        ambientLight.name = "ambientLight"
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        ambientNode.position = SCNVector3Make(0, 50, 50)
        sceneView.scene.rootNode.addChildNode(ambientNode)
    }
    
    func runSession() {
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [.horizontal, .vertical]
        } else {
            configuration.planeDetection = .horizontal
        }
        
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
    
    func updateTrackingInfo() {
        guard let frame = sceneView.session.currentFrame else {
            return
        }
        
        switch frame.camera.trackingState {
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                infoLabel.text = "Limited Tracking: Excessive Motion"
            case .insufficientFeatures:
                infoLabel.text = "Limited Tracking: Insufficient Details"
            default:
                infoLabel.text = "Limited Tracking"
            }
        default:
            infoLabel.text = "All seems good :)"
        }
        
        guard let lightEstimate = frame.lightEstimate?.ambientIntensity else {
            return
        }
        
        currentLightEstimate = frame.lightEstimate
        
        if lightEstimate < 100 {
            infoLabel.text = "Limited Tracking: Too Dark"
        }
    }
    
    func updateLights () {
        if let lightInfo = currentLightEstimate {
            omniLight.intensity = lightInfo.ambientIntensity
            omniLight.temperature = lightInfo.ambientColorTemperature
            ambientLight.intensity = lightInfo.ambientIntensity / 2
            ambientLight.temperature = lightInfo.ambientColorTemperature
        }
    }
    
    func updateMeasuringNodes() {
        guard measuringNodes.count > 1 else {
            return
        }
        let firstNode = measuringNodes[0]
        let secondNode = measuringNodes[1]
        let showMeasuring = self.measuringNodes.count == 2
        
        if showMeasuring {
            measure(fromNode: firstNode, toNode: secondNode)
        } else {
            firstNode.removeFromParentNode()
            secondNode.removeFromParentNode()
            measuringNodes.removeFirst(2)
            distanceLabel.text = ""
            
            for node in sceneView.scene.rootNode.childNodes {
                if node.name == "measuringline" {
                    node.removeFromParentNode()
                }
            }
        }
    }
    
    func measure(fromNode: SCNNode, toNode: SCNNode) {
        let measuringLineNode = createLineNode(fromNode: fromNode, toNode: toNode)
        measuringLineNode.name = "measuringline"
        sceneView.scene.rootNode.addChildNode(measuringLineNode)
        
        let dist = fromNode.position.distanceTo(toNode.position)
        let measurementValue = String(format: "%.2f", dist)
        distanceLabel.text = "\(measurementValue) m"
    }
    
}




extension ViewController : ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let _ = anchor as? ARPlaneAnchor {
                //do nothing on initial plane detection anymore
                return
            } else {
                if let path = self.selectedScenePath, path.count > 0 {
                    let modelClone = SCNScene(named: path)!.rootNode.clone()
                    node.addChildNode(modelClone)
                } else {
                    //let's measure some stuff!
                    let measureBubbleNode = createSphereNode(radius: 0.015)
                    node.addChildNode(measureBubbleNode)
                    self.measuringNodes.append(node)
                    self.updateMeasuringNodes()
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        DispatchQueue.main.async {
//            if let planeAnchor = anchor as? ARPlaneAnchor {
//                if #available(iOS 11.3, *) {
//                    guard let metalDevice = MTLCreateSystemDefaultDevice() else {
//                        return
//                    }
//                    
//                    let planeGeometry = planeAnchor.geometry
//                    let plane = ARSCNPlaneGeometry(device: metalDevice)
//                    plane?.update(from: planeGeometry)
//                    plane?.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.1).cgColor
//                    plane?.firstMaterial?.colorBufferWriteMask = []
//                    plane?.firstMaterial?.isDoubleSided = true
//                    node.castsShadow = false
//                    node.renderingOrder = -1
//                    node.geometry = plane
//                }
//            }
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        removeChildren(inNode: node)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateTrackingInfo()
            self.updateLights()
        }
    }

}
