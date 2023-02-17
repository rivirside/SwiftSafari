//
//  Population.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/2/23.
//

import Foundation
import SwiftUI
import Combine


class Population: Identifiable, ObservableObject {
    let id = UUID()
    
    @Published var mice: [Mouse]
    @Published var berries: [Berry]
    
    @Published var generation: Int = 0
    @Published var counter: Int = 0
    
    public let survivalRate = 0.5
    public let width: Int
    public let height: Int
    public let minTargetDistance: Float
    public let mutationRate: Float = 0.005
    
    init(numMice: Int, numBerries: Int,  width: Int, height: Int, minTargetDistance: Float) {
        self.mice = []
        self.berries = []
        
        self.width = width
        self.height = height
        
        self.minTargetDistance = minTargetDistance
        
        for _ in 0..<numMice {
            
            let randomLocation = randomVectorIn(
                minX: 0.1 * Double(width),
                maxX: 0.9 * Double(width),
                minY: 0.1 * Double(height),
                maxY: 0.9 * Double(height)
            )
            
            let mouse = Mouse(
                neuralNetwork: NeuralNetwork(
                    layerSizes: [8,4,4,2],
                    learningRate: 0.2,
                    momentum: 0.2
                ),
                position: randomLocation,
                direction: Vector(
                    x: 0,
                    y: 0),
                velocity: Vector(
                    x: 0,
                    y: 0),
                acceleration: Vector(
                    x: 0,
                    y: 0),
                maxWidth: width,
                maxHeight: height,
                minTargetDistance: 10
            )
            
            self.mice.append(mouse)
            
        }
        
        for _ in 0..<numBerries {
            
            let randomLocation = randomVectorIn(
                minX: 0.1 * Double(width),
                maxX: 0.9 * Double(width),
                minY: 0.1 * Double(height),
                maxY: 0.9 * Double(height)
            )
            
            let berry = Berry(position: randomLocation)
            
            self.berries.append(berry)
        }
    }
}




//MARK: Utility Methods
extension Population {
    
    //Get a random location on the screen
    func randomVectorIn(minX: Double, maxX: Double, minY: Double, maxY: Double) -> Vector {
        let x = Double.random(in: minX...maxX)
        let y = Double.random(in: minY...maxY)
        return Vector(x: x, y: y)
    }
}




//MARK: Main Methods
extension Population {
    func update() {
        var mouses = [Double]()
        for mouse in mice {
            if mouse.dead == false {
                mouse.update(berries: berries)
            }
            mouses.append(mouse.position.x)
        }
        print(mouses)
    }
    
    
    func allMiceDead() -> Bool {
        for mouse in self.mice {
            if !mouse.dead {
                return false
            }
        }
        return true
    }
    
    
    func sortMice() {
        
    }
    
    func nextGeneration() {
        for mouse in self.mice {
            mouse.dead = false
            mouse.position = randomVectorIn(minX: 0.1*Double(width), maxX: 0.9*Double(width), minY: 0.1*Double(height), maxY: 0.9*Double(height))
            mouse.energy = 1000
        }
    }
    
    func exterminateMice() {
        for mouse in mice {
            mouse.dead = true
        }
    }
}
