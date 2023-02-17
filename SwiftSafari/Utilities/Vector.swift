//
//  Vector.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/2/23.
//


import SwiftUI
import Combine

class Vector: ObservableObject {
    @Published public var x: Double
    @Published public var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(vector: Vector) {
        self.x = vector.x
        self.y = vector.y
    }
    
    func add(_ vector: Vector) {
        self.x += vector.x
        self.y += vector.y
    }
    
    func limit(_ max: Double) {
        let magnitudeSquared = (self.x * self.x) + (self.y * self.y)
        let maxSquared = max * max
        if (magnitudeSquared <= maxSquared) {
            return
        }

        let magnitude = sqrt(magnitudeSquared)
        let normalizedX = self.x / magnitude
        let normalizedY = self.y / magnitude
        let newX = normalizedX * max
        let newY = normalizedY * max

        self.x = newX
        self.y = newY
    }
    
    func distance(_ other: Vector) -> Double {
        let diffX = self.x - other.x
        let diffY = self.y - other.y

        let magnitudeSquared = (diffX * diffX) + (diffY * diffY)
        let magnitude = sqrt(magnitudeSquared)

        return magnitude
    }
    
    func subtract(_ other: Vector) -> Vector {
        let result = Vector(x: self.x - other.x, y: self.y - other.y)
        return result
    }

}




