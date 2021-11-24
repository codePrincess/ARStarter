//
//  GameUtilities.swift
//  ARMemory
//
//  Created by Manu Rink on 14.11.21.
//

import Foundation
import RealityKit
import ARKit

enum GameState {
    case notStarted
    case running
    case finished
}

func sameCardTouchedAgain (first: Entity?, second: Entity?) -> Bool {
    guard let fCard = first, let sCard = second else {
        return false
    }
    
    return fCard.name == sCard.name
}

func flipCard (entity: Entity) {
    var flipTransform = entity.transform
    
    if flipTransform.rotation.angle == 0 {
        flipTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
        flipTransform.translation += SIMD3<Float>(0, 0.005, 0)
    }
    else {
        flipTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
        flipTransform.translation -= SIMD3<Float>(0, 0.005, 0)
    }
    
    entity.move(to: flipTransform, relativeTo: entity.parent, duration: 0.25, timingFunction: .easeInOut)
    
    print("--- flipped card \(entity.name)")
}

func showCard (entity: Entity) {
    var flipTransform = entity.transform
    flipTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
    flipTransform.translation -= SIMD3<Float>(0, 0.005, 0)

    entity.move(to: flipTransform, relativeTo: entity.parent, duration: 0.25, timingFunction: .easeInOut)
    
    print("--- show card \(entity.name)")
}

func hideCard (entity: Entity) {
    var flipTransform = entity.transform
    flipTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
    flipTransform.translation += SIMD3<Float>(0, 0.005, 0)

    entity.move(to: flipTransform, relativeTo: entity.parent, duration: 0.25, timingFunction: .easeInOut)
    
    print("--- hide card \(entity.name)")
}

func pairFound (first: Entity?, second: Entity?) -> Bool {
    guard let fCard = first, let sCard = second else {
        return false
    }
    
    print("--- checking pair")
    print("--- last: \(fCard.name.dropLast()), this: \(sCard.name.dropLast())")
    return fCard.name.dropLast().lowercased() == sCard.name.dropLast().lowercased()
}
