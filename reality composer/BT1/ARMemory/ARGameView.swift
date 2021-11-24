//
//  ARGameView.swift
//  ARMemory
//
//  Created by Manu Rink on 07.11.21.

/*
 
 Available functionality:
 ------------------------
 
 1) Flip a card
    Every card has a notification ON TAP installed on
    the RC side called "cupFlip" and is the same for
    every single card.
    We register for the action and let the "handleTapOnEntity"
    method deal with what happens then - currently we
    just flip the card 180° so we can easily toggle the status
 
 2) Flip the whole board
    There is a notification installed on the RC side which
    we can call from our code. It's called "flipTheBoard"
    and currently we call that directly from our native
    SwiftUI button and not from any 3D model interaction.
    Yes - that is really cool, I know 😅.
 
 3) Comparing logic
    For knowing if we flipped two similar cards we need to
    memorize our cards
 
 4) Only two cards are allowed to be flipped to visible at once
    As soon as more than two cards are visible we'll turn the
    first two to invisible again.
 
 5) We know when the game is finished.
    So when all cards are successfully turned by pairs of two
    in a row.
 
 6) We count our turns and measure the elapsed time
    Did we got better? That's why we need to count how many
    turns we needed until finishing the game plus we measure the time
 
 */

import Foundation
import RealityKit
import ARKit

class ARGameView : ARView, ARSessionDelegate {
    var uiViewState : ARViewState!
    
    var boardAnchor : Experience.GameBoard!
    var lastFlippedCard: Entity?
    
    func setupGameBoard () {
        // Load the "Box" scene from the "Experience" Reality File
        boardAnchor = try! Experience.loadGameBoard()
        
        //register all needed actions from RC project
        boardAnchor.actions.cupFlip.onAction = handleTapOnEntity(_:)
        
        let occlusionMaterial = OcclusionMaterial()
        //let simpleMaterial = SimpleMaterial(color: UIColor.red.withAlphaComponent(1), isMetallic: false)
        
        let occlusionBox = ModelEntity(mesh: .generateBox(width: 0.5, height: 0.2, depth: 0.5), materials: [occlusionMaterial])
        occlusionBox.transform.translation -= SIMD3<Float>(0, 0.1, 0)
        
        // Add the box anchor to the scene
        boardAnchor.addChild(occlusionBox)
        self.scene.anchors.append(boardAnchor)
    }
    
    func handleTapOnEntity(_ entity: Entity?) {
        
        if !(uiViewState.gameState == GameState.running) {
            return
        }
        
        if let animatable = entity {
            
            flipCard(entity: animatable)
            
        }
    }
    
    

}
