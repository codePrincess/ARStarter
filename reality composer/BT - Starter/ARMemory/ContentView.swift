//
//  ContentView.swift
//  ARMemory
//
//  Created by Manu Rink on 07.11.21.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    @StateObject var arViewState = ARViewState()
    
    var body: some View {
        ZStack {
            
            ARViewContainer(viewState: arViewState).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                if arViewState.gameState == .notStarted {
                    VStack {
                        Text("Welcome to AR Memory 🙌")
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                        Text("Hit the start button and challenge yourself with a decent game of memory directly where you are in AR!")
                            .foregroundColor(Color(.systemGray2))
                            .font(.body)
                        Spacer()
                        
                        Button("Start game") {
                            arViewState.startGame()
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .font(.title2)
                        .cornerRadius(10)
                    }
                    .frame(width: 300, height: 250)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                }
            }
        }
    }
}

class ARViewState : ObservableObject {
    weak var arView : ARGameView?
    @Published var gameState : GameState = .notStarted
    
    func startGame () {
        gameState = arView!.turnAllCards()
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @StateObject var viewState : ARViewState
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARGameView(frame: .zero)
        arView.uiViewState = viewState
        
        arView.setupGameBoard()
        
        viewState.arView = arView
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
