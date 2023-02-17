//
//  Organism.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/4/23.
//

import Foundation


class Organism: Identifiable, ObservableObject {
    public let id = UUID()
    
    //Organism
    @Published public var neuralNetwork: NeuralNetwork
    
    //Generation
    @Published public var dead: Bool = false
    @Published public var success: Bool = false
    @Published public var champion: Bool = false
    @Published public var score: Double = 0
    
    //Movement
    @Published public var position: Vector
    @Published var direction: Vector
    @Published var velocity: Vector
    @Published var acceleration: Vector
    
    //Stats
    @Published var energy: Double = 1000
    @Published var health: Double = 100
    
    
    //Constraints
    public let maxWidth: Int
    public let maxHeight: Int
    public let minTargetDistance: Double
    
    //Graphics
    let size: Double = 10
    
    init(neuralNetwork: NeuralNetwork, position: Vector, direction: Vector, velocity: Vector, acceleration: Vector, maxWidth: Int, maxHeight: Int, minTargetDistance: Double) {
        self.neuralNetwork = neuralNetwork
        
        self.position = position
        self.direction = direction
        self.velocity = velocity
        self.acceleration = acceleration
        
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.minTargetDistance = minTargetDistance
    }
    
}



//MARK: Methods

extension Organism {
    
    func scoreUpdate(berries: [Berry]) {
        let nearestBerry = nearestBerry(berries: berries)
        let distance = position.distance(nearestBerry.position)
        score += distance
    }
    
    func nearestBerry(berries: [Berry]) -> Berry {
        
        var closestBerry = berries[0]
        
        for berry in berries {
            
            if berry.fresh == true {
                if position.distance(berry.position) < position.distance(closestBerry.position) {
                    closestBerry = berry
                }
            }
        }
        
        return closestBerry
    }
    
    
    func outBounds() -> Bool {
        var bool = false
        if self.position.x < 0 {
            bool = true
        } else if self.position.x > Double(self.maxWidth) {
            bool = true
        } else if self.position.y < 0 {
            bool = true
        } else if self.position.y > Double(self.maxHeight) {
            bool = true
        }
        return bool
    }
}
