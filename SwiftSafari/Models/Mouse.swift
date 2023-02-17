//
//  Mouse.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/2/23.
//

import Foundation
import SwiftUI
import Combine


class Mouse: Organism {
    
}



//MARK: Methods
extension Mouse {
    
    func update(berries: [Berry]) {
        //Check it found berry
        
        //Check if out of bounds
        if outBounds() {
            self.dead = true
            return
        }
        
        //find nearest Berry
        let nearestBerry = nearestBerry(berries: berries)
        
        //Calculate inputs for the neural network
        let inputs = [
            self.position.x,
            self.position.y,
            self.velocity.x,
            self.velocity.y,
            self.acceleration.x,
            self.acceleration.y,
            nearestBerry.position.x,
            nearestBerry.position.y
        ]
        
        //Calculate outputs of neural network
        let outputs = self.neuralNetwork.feedForward(inputs: inputs, activationFunction: neuralNetwork.tanh)
        
        // Update the acceleration based on the output of the neural network
        self.acceleration = Vector(
            x: outputs[0],
            y: outputs[1]
        )
        
        // Update the velocity based on the acceleration
        self.velocity.add(acceleration)
        
        // Limit the velocity to the maximum velocity
        self.velocity.limit(1)
        
        
        // Update the position based on the velocity
        self.position.add(velocity)
        
        self.energy -= 0.5
        
        if self.energy <= 0 {
            self.dead = true
        }
        
        scoreUpdate(berries: berries)
        
    }
    
    
    func eatBerry(berry: Berry) {
        if self.position.distance(berry.position) < minTargetDistance {
            berry.fresh = false
            self.energy = 1000
        }
    }

    
    
}
