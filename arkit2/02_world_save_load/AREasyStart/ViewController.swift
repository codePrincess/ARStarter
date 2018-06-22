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
    @IBOutlet weak var saveWorldButton: UIButton!
    @IBOutlet weak var loadWorldButton: UIButton!
    
    var sunshineSystem : SCNParticleSystem?
    var timer : Timer?
    
    var postitIndex = 0
    var alert : UIAlertController?
    
    
    var worldFileURL : URL?
    
    var screenCenter: CGPoint {
        let screenSize = view.bounds
        return CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        let fileName = "worldmap"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        worldFileURL = DocumentDirURL.appendingPathComponent(fileName)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveWorldMap () {
        sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            try? data.write(to: self.worldFileURL!)
        }
    }
    
    func openWorldMap () throws {
        let mapData = try Data(contentsOf: worldFileURL!)
        guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(of: ARWorldMap.classForKeyedUnarchiver(), from: mapData) as? ARWorldMap
            else { throw ARError(.invalidWorldMap) }
        runSession(worldMap)
    }
    
    @IBAction func runSessionTapped(_ sender: Any) {
        runSession()
    }
    
    @IBAction func saveWorldTapped(_ sender: Any) {
        saveWorldMap()
        alert = UIAlertController(title: "World saved", message: "The ARWorldMap and all elements were sucessfully saved.", preferredStyle: .alert)
        self.present(alert!, animated: true)
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
            self.alert?.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func openWorldTapped(_ sender: Any) {
        try? openWorldMap()
        alert = UIAlertController(title: "World loading...", message: "Loading a map works best when you explore the environment. \nMove your phone around and we'll be up in a second!", preferredStyle: .alert)
        self.present(alert!, animated: true)
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { timer in
            self.alert?.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func sceneTapped(_ sender: UITapGestureRecognizer) {
        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        // Place an anchor for a virtual character. The model appears in renderer(_:didAdd:for:).
        let anchor = ARAnchor(name: "postit", transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
    }
    
    func runSession(_ map: ARWorldMap? = nil) {
        DispatchQueue.main.async {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.vertical]
            if let theMap = map {
                configuration.initialWorldMap = theMap
            }
            self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
//            if let planeAnchor = anchor as? ARPlaneAnchor {
//                let planeNode = createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
//                planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.1).cgColor
//                planeNode.geometry?.firstMaterial?.colorBufferWriteMask = []
//                planeNode.geometry?.firstMaterial?.isDoubleSided = true
//                planeNode.castsShadow = false
//                planeNode.renderingOrder = -1
//                node.addChildNode(planeNode)
//            }
            if let name = anchor.name, name.hasPrefix("postit") {
                let sceneURL = Bundle.main.url(forResource: "postit", withExtension: "scn", subdirectory: "art.scnassets")
                let refNode = SCNReferenceNode(url: sceneURL!)!
                refNode.load()
                
                let postit = refNode.childNode(withName: "postit", recursively: true)?.childNodes[self.postitIndex]
                node.addChildNode(postit!)
                
                self.postitIndex = self.postitIndex >= 5 ? 0 : self.postitIndex + 1
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        DispatchQueue.main.async {
//            if let planeAnchor = anchor as? ARPlaneAnchor {
//                updatePlaneNode(node.childNodes[0], center: planeAnchor.center, extent: planeAnchor.extent)
//            }
//        }
    }

}
