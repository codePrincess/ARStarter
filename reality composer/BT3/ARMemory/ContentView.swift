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
                
                let _ = print("+++ UI Updated")
                
                if arViewState.gameState == .notStarted {
                    VStack {
                        Text("Welcome to AR Memory 🙌")
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                        Text("Hit the start button and challenge yourself with a decent game of memory direc tly where you are in AR.")
                            .foregroundColor(Color(.systemGray2))
                            .font(.body)
                        
                        Spacer()
                        
                        VStack {
                            Button("Start game") {
                                arViewState.turnTable()
                            }
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .font(.title2)
                            .cornerRadius(10)
                        }
                        
                        Spacer(minLength: 5)
                    }
                    .frame(width: 300, height: 250)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(15)
                }
                
                if arViewState.gameState == .running {
                    VStack{
                        HStack {
                            VStack {
                                Text("Taken Turns")
                                    .bold()
                                    .foregroundColor(Color(.systemGray6))
                                
                                Text("\(arViewState.turns)")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding(2)
                            }
                            Spacer()
                            VStack {
                                Text("Time Elapsed")
                                    .bold()
                                    .foregroundColor(Color(.systemGray6))
                                Text(arViewState.timeElapsed)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding(2)
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(width: 300, height: 100)
                    .padding()
                    .background(Color(.systemGray4))
                    .cornerRadius(15)
                }
                
                if arViewState.gameState == .finished {
                    
                    VStack {
                        Text("Congratulations 🎉")
                            .foregroundColor(.black)
                            .font(.title2)
                        
                        Spacer()
                        
                        Text("You finished the game in no time. Genius!\nYou just turned \(arViewState.turns) pairs of cards in swift \(arViewState.timeElapsed).\nWanna try again?")
                            .foregroundColor(Color(.systemGray))
                            .font(.body)
                        
                        Spacer()
                        
                        VStack {
                            Button("Start again") {
                                arViewState.resetGame()
                                arViewState.turnTable()
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .font(.title2)
                            .cornerRadius(10)
                        }
                        
                        Spacer(minLength: 5)
                    }
                    .frame(width: 300, height: 250)
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(15)
                }
            }
            
            
        }
    }
}

class ARViewState : ObservableObject {
    
    weak var arView : ARGameView?
    @Published var gameState : GameState = .notStarted
    @Published var turns : Int = 0
    @Published var timeElapsed : String = "0:00"
    
    func resetGame () {
        arView?.resetGame()
        arView?.setupGameBoard()
    }
    
    func turnTable () {
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
