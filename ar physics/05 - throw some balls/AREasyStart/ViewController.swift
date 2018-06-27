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

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var showTime: UILabel!
    @IBOutlet weak var infoBgView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var shootArrow: UIButton!
    @IBOutlet weak var startTimer: UIButton!
    @IBOutlet weak var balloonCountLabel: UILabel!
    
    let omniLight = SCNLight()
    let ambientLight = SCNLight()
    var currentLightEstimate : ARLightEstimate?

    var countdownTimer: Timer!
    var totalTime = 60
    var balloonCount = 0
    
    var screenCenter: CGPoint {
        let screenSize = view.bounds
        return CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    }
    var balloonsInRoom: [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "All seems good :)"

        updateUI()
        
        startTimer.layer.cornerRadius = 15
        shootArrow.layer.cornerRadius = 50
        showTime.layer.cornerRadius = 15
        showTime.clipsToBounds = true
        balloonCountLabel.layer.cornerRadius = 20
        balloonCountLabel.clipsToBounds = true
        
        
        runSession()
        addLightToScene()
        configureWorldBottom()
        loadAudio()
    }
    
    func updateUI () {
        if (startTimer.isHidden == true ){
            shootArrow.isHidden = false
            infoLabel.isHidden = false
            balloonCountLabel.isHidden = false
            showTime.isHidden = false
        } else{
            shootArrow.isHidden = true
            infoLabel.isHidden = true
            balloonCountLabel.isHidden = true
            showTime.isHidden = true
        }
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
    
    
    @IBAction func shootArrowToBalloon(_ sender: UIButton) {
        shootBall()
        
        if (totalTime < 1){
            startTimer.isHidden = false
            updateUI()
        }
    }
    
    
    @IBAction func sartTimerTapped(_ sender: UIButton) {
        startTimerFunktion()
    }
    
    func addLightToScene () {
        omniLight.type = .omni
        omniLight.name = "omniLight"
        let spotNode = SCNNode()
        spotNode.light = omniLight
        spotNode.position = SCNVector3Make(0, 50, 0)
        
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
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
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
    
    
    func configureWorldBottom() {
        let bottomPlane = SCNBox(width: 100, height: 0.005, length: 100, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(white: 1.0, alpha: 0.0)
        bottomPlane.materials = [material]
        
        let bottomNode = SCNNode(geometry: bottomPlane)
        bottomNode.position = SCNVector3(x: 0, y: -10, z: 0)
        
        let physicsBody = SCNPhysicsBody.static()
        physicsBody.categoryBitMask = CollisionTypes.bottom.rawValue
        physicsBody.contactTestBitMask = CollisionTypes.shape.rawValue
        bottomNode.physicsBody = physicsBody
        
        self.sceneView.scene.rootNode.addChildNode(bottomNode)
        self.sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    func startTimerFunktion() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startTimer.isHidden = true
        
        updateUI()
        balloonCreation()
    }
    
    @objc func updateTime() {
        showTime.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        stopWholeGame()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func stopWholeGame() {
        totalTime = 60
        startTimer.isHidden = false
        updateUI()
        
        showTime.text = "Game over!"
        balloonCount = 0
        balloonCountLabel.text = "\(balloonCount)"
        removeChildren(inNode: sceneView.scene.rootNode)
    }
    

    
    func balloonCreation() {
        let balloonScene = SCNScene(named: "art.scnassets/ballon.scn")
        let balloonNode = balloonScene?.rootNode.childNode(withName: "myballoon", recursively: true)
        
        for _ in 0...20 {
            let newBalloon = balloonNode?.clone()
            
            let randomizerx = GKRandomDistribution(randomSource: GKRandomSource(), lowestValue: -20, highestValue: 20)
            let randomizery = GKRandomDistribution(randomSource: GKRandomSource(), lowestValue: 1, highestValue: 6)
            let randomizerz = GKRandomDistribution(randomSource: GKRandomSource(), lowestValue: -20, highestValue: 20)
            
            let randomNumberInBoundsx = randomizerx.nextInt()
            let randomNumberInBoundsy = randomizery.nextInt()
            let randomNumberInBoundsz = randomizerz.nextInt()
            
            newBalloon?.position.x = Float(randomNumberInBoundsx)
            newBalloon?.position.y = Float(randomNumberInBoundsy)
            newBalloon?.position.z = Float(randomNumberInBoundsz)
            
            balloonsInRoom.append(newBalloon!)
            sceneView.scene.rootNode.addChildNode(newBalloon!)
        }
    }
    
    func shootBall(){
        let balloonScene = SCNScene(named: "art.scnassets/arrow.scn")
        
        let ballNode = balloonScene?.rootNode.childNode(withName: "ballnode", recursively: true)
        
        var translation = matrix_identity_float4x4
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        translation.columns.3.z = -0.3
        ballNode?.simdTransform = matrix_multiply(cameraTransform!, translation)
        
        let ballPhysicsBody = SCNPhysicsBody.dynamic()
        ballPhysicsBody.mass = 1
        ballPhysicsBody.friction = 2
        ballPhysicsBody.categoryBitMask = CollisionTypes.shape.rawValue
        ballPhysicsBody.contactTestBitMask = 1
        ballNode?.physicsBody = ballPhysicsBody
        
        var worldFront = (ballNode?.worldFront)!
        worldFront.x *= 25
        worldFront.y *= 25
        worldFront.z *= 25
        
        ballNode?.physicsBody?.applyForce(worldFront, asImpulse: true)
    
        sceneView.scene.rootNode.addChildNode(ballNode!)
    }
}




extension ViewController : ARSCNViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        infoLabel.text = error.localizedDescription
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        infoLabel.text = "Session interupted :("
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        infoLabel.text = "Session resumed - wait a sec!"
        for node in sceneView.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
        runSession()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateTrackingInfo()
            self.updateLights()
        }
    }

}


extension ViewController : SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let mask = contact.nodeA.physicsBody!.categoryBitMask | contact.nodeB.physicsBody!.categoryBitMask
        
        //ball hits baloon
        if  let nameA = contact.nodeA.name,
            let nameB = contact.nodeB.name {
            if nameA == "MainBalloon" && nameB == "ballnode" {
                contact.nodeA.parent?.parent?.removeFromParentNode()
                balloonCount += 1
                balloonCountLabel.text = "\(balloonCount)"
                return
            }
        }
        
        //ball hits plane
        if CollisionTypes(rawValue: mask) == [CollisionTypes.bottom, CollisionTypes.shape] {
            if contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.bottom.rawValue {
                contact.nodeB.removeFromParentNode()
                print("collision: nodeB removed")

            } else {
                contact.nodeA.removeFromParentNode()
                print("collision: nodeA removed")
            }
        }
    }
    
}
