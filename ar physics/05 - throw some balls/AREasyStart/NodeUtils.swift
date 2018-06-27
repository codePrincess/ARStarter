import SceneKit
import ARKit
import GameplayKit

func nodeWithModelName(_ modelName: String) -> SCNNode {
    return SCNScene(named: modelName)!.rootNode.clone()
}

func createPlaneNode(center: vector_float3, extent: vector_float3) -> SCNNode {
    let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
    
    let planeMaterial = SCNMaterial()
    planeMaterial.diffuse.contents = UIColor.blue.withAlphaComponent(0.4)
    plane.materials = [planeMaterial]
    let planeNode = SCNNode(geometry: plane)
    planeNode.position = SCNVector3Make(center.x, 0, center.z)
    planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
    
    return planeNode
}

func updatePlaneNode(_ node: SCNNode, center: vector_float3, extent: vector_float3) {
    let geometry = node.geometry as! SCNPlane
    
    geometry.width = CGFloat(extent.x)
    geometry.height = CGFloat(extent.z)
    node.position = SCNVector3Make(center.x, 0, center.z)
}

func addPhysicsToSimplePlane(_ node: SCNNode) {
    node.physicsBody = SCNPhysicsBody.kinematic()
    
    let geometry = node.geometry as! SCNPlane
    
    node.physicsBody?.physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
    print("physics shape of plane: \(geometry.width) / \(geometry.height)")
    node.physicsBody?.restitution = 0.0
    node.physicsBody?.friction = 1.0
}

func addPhysicsToPlane(_ node: SCNNode) {
    if #available(iOS 11.3, *) {
        let geo = node.geometry as! ARSCNPlaneGeometry
        let boundingSphere = geo.boundingSphere

        if let plane = node.childNode(withName: "physicsplane", recursively: true) {
            plane.removeFromParentNode()
        }

        let plane = SCNPlane(width: CGFloat(boundingSphere.radius), height: CGFloat(boundingSphere.radius))
        plane.cornerRadius = 50

        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.red.withAlphaComponent(0.3)
        plane.materials = [planeMaterial]

        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "physicsplane"
        planeNode.position = SCNVector3Make(boundingSphere.center.x, 0, boundingSphere.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

        node.addChildNode(planeNode)

        planeNode.physicsBody = nil
        planeNode.physicsBody = SCNPhysicsBody.kinematic()
        planeNode.physicsBody?.physicsShape = SCNPhysicsShape(geometry: plane, options: nil)
        planeNode.physicsBody?.mass = 100 //mass in kg!
        planeNode.physicsBody?.restitution = 0.0
        planeNode.physicsBody?.friction = 1.0
    }
}

func updatePhysicsOnBoxes (_ model: SCNNode) {
    let boxNode = model.childNode(withName: "mybox", recursively: true)
    if let node = boxNode {
        var scale = GKRandomSource.sharedRandom().nextUniform()
        scale = scale < 0.5 ? 0.5 : scale
        node.scale = SCNVector3(x: scale, y: scale, z: scale)
        node.physicsBody = nil
        
        let physicsBody = SCNPhysicsBody.dynamic()
        physicsBody.mass = CGFloat(scale)
        physicsBody.restitution = 0.1
        physicsBody.friction = 0.75
        physicsBody.damping = 0.3
        physicsBody.categoryBitMask = CollisionTypes.shape.rawValue
        node.physicsBody = physicsBody
        node.position.y = 0.2
    }
}

func removeChildren(inNode node: SCNNode) {
    for node in node.childNodes {
        if let name = node.name, name.contains("plane") {
            //found plane - do nothing ;)
        } else {
            node.removeFromParentNode()
        }
    }
}

func createSphereNode(radius: CGFloat) -> SCNNode {
    let sphere = SCNSphere(radius:radius)
    sphere.firstMaterial?.diffuse.contents = UIColor.red
    return SCNNode(geometry: sphere)
}

func createLineNode(fromNode: SCNNode, toNode: SCNNode) -> SCNNode {
    let line = lineFrom(vector: fromNode.position, toVector: toNode.position)
    let lineNode = SCNNode(geometry: line)
    let planeMaterial = SCNMaterial()
    planeMaterial.diffuse.contents = UIColor.red
    line.materials = [planeMaterial]
    return lineNode
}

func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
    let indices: [Int32] = [0, 1]
    
    let source = SCNGeometrySource(vertices: [vector1, vector2])
    let element = SCNGeometryElement(indices: indices, primitiveType: .line)
    
    return SCNGeometry(sources: [source], elements: [element])
}

func applyForce(to node: SCNNode) {
    let forceX = Float(GKRandomSource.sharedRandom().nextInt(upperBound: 3))
    let forceY = Float(GKRandomSource.sharedRandom().nextInt(upperBound: 3))
    let forceZ = Float(GKRandomSource.sharedRandom().nextInt(upperBound: 3))
    node.physicsBody?.applyForce(SCNVector3Make(forceX, forceY, forceZ), asImpulse: true)
}

var boxKickedAudioSource: SCNAudioSource = {
    let source = SCNAudioSource(fileNamed: "sounds/whoosh.aiff")!
    
    source.isPositional = true
    source.volume = 0.6
    
    return source
}()

func loadAudio() {
    boxKickedAudioSource.load()
    print("sound loaded")
}

func playSound (for node: SCNNode) {
    node.runAction(
        SCNAction.playAudio(boxKickedAudioSource, waitForCompletion: true))
    print("sound played: \(boxKickedAudioSource)")
}

func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

struct CollisionTypes : OptionSet {
    let rawValue: Int
    
    static let bottom  = CollisionTypes(rawValue: 1 << 0)
    static let shape = CollisionTypes(rawValue: 1 << 1)
}

extension SCNVector3 {
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    func distanceTo(_ vector: SCNVector3) -> Float {
        return SCNVector3(x: self.x - vector.x, y: self.y - vector.y, z: self.z - vector.z).length()
    }
}
