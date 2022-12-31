//
//  Neural Network.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 12/31/22.
//

import Foundation
import Combine
import SwiftUI


struct NeuralNetwork {
    public var inputLayer: [Float]
    public var hiddenLayer: [Float]
    public var outputLayer: [Float]
    public var weightsIH: [[Float]]
    public var weightsHO: [[Float]]
    public var learningRate: Float
    public var momentum: Float
    public var prevWeightUpdatesIH: [[Float]]
    public var prevWeightUpdatesHO: [[Float]]

    // Activation function
    func sigmoid(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }

    func sigmoidDerivative(x: Float) -> Float {
        return x * (1 - x)
    }
    //tanh instead because it allows for  negative output values
    func tanh(x: Float) -> Float {
        return (2.0 / (1.0 + exp(-2.0 * x))) - 1.0
    }

    func tanhDerivative(x: Float) -> Float {
        let y = tanh(x: x)
        return 1 - y * y
    }


    init(inputNodes: Int, hiddenNodes: Int, outputNodes: Int, learningRate: Float = 0.1, momentum: Float = 0.9) {
        self.inputLayer = [Float](repeating: 0.0, count: inputNodes)
        self.hiddenLayer = [Float](repeating: 0.0, count: hiddenNodes)
        self.outputLayer = [Float](repeating: 0.0, count: outputNodes)
        self.weightsIH = [[Float]](repeating: [Float](repeating: 0.0, count: hiddenNodes), count: inputNodes)
        self.weightsHO = [[Float]](repeating: [Float](repeating: 0.0, count: outputNodes), count: hiddenNodes)
        self.learningRate = learningRate
        self.momentum = momentum
        self.prevWeightUpdatesIH = [[Float]](repeating: [Float](repeating: 0.0, count: hiddenNodes), count: inputNodes)
        self.prevWeightUpdatesHO = [[Float]](repeating: [Float](repeating: 0.0, count: outputNodes), count: hiddenNodes)

        // Randomize weights
        for i in 0..<self.weightsIH.count {
            for j in 0..<self.weightsIH[i].count {
                self.weightsIH[i][j] = Float.random(in: -1...1)
            }
        }

        for i in 0..<self.weightsHO.count {
            for j in 0..<self.weightsHO[i].count {
                self.weightsHO[i][j] = Float.random(in: -1...1)
            }
        }
    }


    mutating func train(inputs: [Float], expectedOutputs: [Float]) {
        // Forward pass
        for i in 0..<inputs.count {
            self.inputLayer[i] = inputs[i]
        }
        for i in 0..<hiddenLayer.count {
            var sum = 0.0
            for j in 0..<inputLayer.count {
                sum += Double(inputLayer[j] * weightsIH[j][i])
            }
            hiddenLayer[i] = tanh(x: Float(sum))
        }
        for i in 0..<outputLayer.count {
            var sum = 0.0
            for j in 0..<hiddenLayer.count {
                sum += Double(hiddenLayer[j] * weightsHO[j][i])
            }
            outputLayer[i] = tanh(x: Float(sum))
        }

        // Calculate errors
        let outputErrors = expectedOutputs.enumerated().map { (i, output) -> Float in
            return output - outputLayer[i]
        }
        let hiddenErrors = hiddenLayer.enumerated().map { (i, hidden) -> Float in
            var sum = 0.0
            for j in 0..<outputErrors.count {
                sum += Double(outputErrors[j] * weightsHO[i][j])
            }
            return Float(sum) * tanhDerivative(x: hidden)
        }

        // Update weights
        for i in 0..<inputLayer.count {
            for j in 0..<hiddenErrors.count {
                // Calculate weight update using momentum
                let momentum = 0.9
                let prevWeightDelta = weightsIH[i][j] - weightsIH[i][j]
                weightsIH[i][j] += learningRate * hiddenErrors[j] * inputLayer[i] + Float(momentum) * prevWeightDelta
            }
        }
        for i in 0..<hiddenLayer.count {
            for j in 0..<outputErrors.count {
                // Calculate weight update using momentum
                let momentum = 0.9
                let prevWeightDelta = weightsHO[i][j] - weightsHO[i][j]
                weightsHO[i][j] += learningRate * outputErrors[j] * hiddenLayer[i] + Float(momentum) * prevWeightDelta
            }
        }
    }


    mutating func predict(inputs: [Float]) -> [Float] {
        // Forward pass
        for i in 0..<inputs.count {
            self.inputLayer[i] = inputs[i]
        }
        for i in 0..<hiddenLayer.count {
            var sum = 0.0
            for j in 0..<inputLayer.count {
                sum += Double(inputLayer[j] * weightsIH[j][i])
            }
            hiddenLayer[i] = tanh(x: Float(sum))
        }
        for i in 0..<outputLayer.count {
            var sum = 0.0
            for j in 0..<hiddenLayer.count {
                sum += Double(hiddenLayer[j] * weightsHO[j][i])
            }
            outputLayer[i] = tanh(x: Float(sum))
        }

        return outputLayer
    }



    mutating func mutate(mutationRate: Double, minWeight: Double, maxWeight: Double) {
        for i in 0..<weightsIH.count {
            for j in 0..<weightsIH[i].count {
                if Double.random(in: 0...1) < mutationRate {
                    weightsIH[i][j] = Float(max(min(Double(weightsIH[i][j]) + Double.random(in: -1...1), maxWeight), minWeight))
                }
            }
        }
        for i in 0..<weightsHO.count {
            for j in 0..<weightsHO[i].count {
                if Double.random(in: 0...1) < mutationRate {
                    weightsHO[i][j] = Float(max(min(Double(weightsHO[i][j]) + Double.random(in: -1...1), maxWeight), minWeight))
                }
            }
        }
    }


}

