//
//  ViewController.swift
//  SolarSystem
//
//  Created by Manu Rink on 29.05.18.
//  Copyright © 2018 microsoft. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        createSolarSystem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func createSolarSystem() {
        
        //parent Node
        let sun = SCNNode()
        sun.position.z = -1.5
        
        //planets
        let mercury = Planet(name: "mercury", radius: 0.14, rotation: 32.degreesToRadians, color: .orange, distance: 1.3)
        let venus = Planet(name: "venus", radius: 0.35, rotation: 10.degreesToRadians, color: .cyan, distance: 2)
        let earth = Planet(name: "earth", radius: 0.5, rotation: 18.degreesToRadians, color: .blue, distance: 7)
        let saturn = Planet(name: "saturn", radius: 1, rotation: 12.degreesToRadians, color: .brown, distance: 12)
        
        let planets = [mercury, venus, earth, saturn]
        
        for planet in planets {
            let planetNode = createNode(from : planet)
            sun.addChildNode(planetNode)
        }
        
        //light
        let light = SCNLight()
        light.type = .omni
        sun.light = light
        
        //stars
        let stars = SCNParticleSystem(named: "art.scnassets/stars.scnp", inDirectory: nil)!
        sun.addParticleSystem(stars)
        
        //sun
        let sunFire = SCNParticleSystem(named: "art.scnassets/sun.scnp", inDirectory: nil)!
        sun.addParticleSystem(sunFire)
        
        sceneView.scene.rootNode.addChildNode(sun)
    }
    
    func createNode(from planet : Planet) -> SCNNode {
        let parentNode = SCNNode()
        let rotateAction = SCNAction.rotateBy(x: 0, y: planet.rotation, z: 0, duration: 1)
        parentNode.runAction(.repeatForever(rotateAction))
        
        let sphereGeometry = SCNSphere(radius: planet.radius)
        sphereGeometry.firstMaterial?.diffuse.contents = planet.color
        
        let planetNode = SCNNode(geometry: sphereGeometry)
        planetNode.position.z = -planet.distance
        planetNode.name = planet.name
        parentNode.addChildNode(planetNode)
        
        if planet.name == "saturn" {
            let ringGeometry = SCNTube(innerRadius: 1.2, outerRadius: 1.8, height: 0.05)
            ringGeometry.firstMaterial?.diffuse.contents = UIColor.darkGray
            
            let ringNode = SCNNode(geometry: ringGeometry)
            ringNode.eulerAngles.x = Float(10.degreesToRadians)
            planetNode.addChildNode(ringNode)
        }
        
        return parentNode
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
