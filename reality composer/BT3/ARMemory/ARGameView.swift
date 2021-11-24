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
    
    private let pairsNeeded = 2
    var pairsFound = 0

    var tapCount : Int = 0
    var lastFlippedCard: Entity?

    var boardAnchor : Experience.GameBoard!
    
    var timer : Timer!
    var timerSeconds : Int = 0
    
    func setupGameBoard () {
        // Load the "Box" scene from the "Experience" Reality File
        boardAnchor = try! Experience.loadGameBoard()
        
        //register all needed actions from RC project
        boardAnchor.actions.cupFlip.onAction = handleTapOnEntity(_:)
        boardAnchor.actions.boardFlipped.onAction = handleOnTurnAll(_:)
        
        let occlusionMaterial = OcclusionMaterial()
        //let simpleMaterial = SimpleMaterial(color: UIColor.red.withAlphaComponent(1), isMetallic: false)
        
        let occlusionBox = ModelEntity(mesh: .generateBox(width: 0.5, height: 0.2, depth: 0.5), materials: [occlusionMaterial])
        occlusionBox.transform.translation -= SIMD3<Float>(0, 0.1, 0)
        
        // Add the box anchor to the scene
        boardAnchor.addChild(occlusionBox)
        self.scene.anchors.append(boardAnchor)
    }
    
    func resetGame () {
        uiViewState.turns = 0
        uiViewState.timeElapsed = "0:00"
        uiViewState.gameState = .notStarted
        
        pairsFound = 0
        tapCount = 0
        lastFlippedCard = nil
        timerSeconds = 0
        
        boardAnchor.removeFromParent()
    }
    
    func turnAllCards() -> GameState {
        boardAnchor.notifications.flipTheBoard.post()
        print("will turn all cards")
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        return .running
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
        timerSeconds += 1
        let minutes = timerSeconds/60
        let stringMinutes = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let seconds = timerSeconds%60
        let stringSeconds = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        uiViewState.timeElapsed = "\(stringMinutes):\(stringSeconds)"
    }
    
    func handleOnTurnAll(_ entity: Entity?) {
        print("all cards turned")
    }
    
    func handleTapOnEntity(_ entity: Entity?) {
        
        if let animatable = entity {
            
            //if game is not started yet no cards can be turned
            if !(uiViewState.gameState == .running) {
                return
            }
            
            //check if same card is touched again
            if sameCardTouchedAgain(first: animatable, second: lastFlippedCard) {
                return
            }
            
            showCard(entity: animatable)
            
            if pairFound(first: animatable, second: lastFlippedCard) {
                print(" +++ PAIR FOUND -> \(animatable.name)")
                pairsFound += 1
                
                showStarInSceneForFoundPair()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.lastFlippedCard?.removeFromParent()
                    animatable.removeFromParent()
                    self.lastFlippedCard = nil
                }
                
                if pairsFound == pairsNeeded {
                    print(" +++ GAME WON (with \(tapCount/2 + 1) tries)+++")
                    
                    uiViewState.gameState = .finished
                    timer.invalidate()
                    timer = nil
                }

            }
            //no pair found
            else {
                //two cards turned - hide both cards again and reset lastFlippedCard
                if let card = lastFlippedCard {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        hideCard(entity: card)
                        hideCard(entity: animatable)
                    }
                    lastFlippedCard = nil
                //only one card turned - memorize as lastflippedcard
                } else {
                    lastFlippedCard = animatable
                }
            }
            
            tapCount += 1
            uiViewState.turns = tapCount/2
            
        }
    }
    

    
    func showStarInSceneForFoundPair () {
        switch pairsFound {
        case 1: boardAnchor.notifications.showStar1.post()
        case 2: boardAnchor.notifications.showStar2.post()
        case 3: boardAnchor.notifications.showStar3.post()
        default: print(" ‼️ star needed in RC for \(pairsFound) result")
        }
    }
    
    

}
