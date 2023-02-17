//
//  Neural Network.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 12/31/22.
//visualization
//https://ml4a.github.io/ml4a/looking_inside_neural_nets/

import Foundation
import Combine
import SwiftUI



//MARK: Struct

struct NeuralNetwork {
  // The number of layers in the network, including the input and output layers
  let layerCount: Int
  // The number of nodes in each layer
  let layerSizes: [Int]
  // The weights of the connections between nodes
  var weights: [[[Double]]]
  // The biases of the nodes
  var biases: [[Double]]
  // The learning rate hyperparameter
  let learningRate: Double
  // The momentum hyperparameter
  let momentum: Double
  // The weight update from the previous iteration
  var previousWeightDeltas: [[[Double]]]
  // The bias update from the previous iteration
  var previousBiasDeltas: [[Double]]
    
    // Initialize the network with random weights and biases
    init(layerSizes: [Int], learningRate: Double, momentum: Double) {
        self.layerCount = layerSizes.count
        self.layerSizes = layerSizes
        self.learningRate = learningRate
        self.momentum = momentum

        // Initialize the weights and biases with random values
        self.weights = []
        self.biases = []
        self.previousWeightDeltas = []
        self.previousBiasDeltas = []
        for i in 0..<(layerCount - 1) {
          let layerSize = layerSizes[i]
          let nextLayerSize = layerSizes[i + 1]
          var layerWeights: [[Double]] = []
          var layerBiases: [Double] = []
          var layerWeightDeltas: [[Double]] = []
          var layerBiasDeltas: [Double] = []
          for _ in 0..<nextLayerSize {
            var nodeWeights: [Double] = []
            var nodeWeightDeltas: [Double] = []
            for _ in 0..<layerSize {
              nodeWeights.append(Double.random(in: -1...1))
              nodeWeightDeltas.append(0)
            }
            layerWeights.append(nodeWeights)
            layerWeightDeltas.append(nodeWeightDeltas)
                    layerBiases.append(Double.random(in: -1...1))
            layerBiasDeltas.append(0)
          }
          self.weights.append(layerWeights)
          self.biases.append(layerBiases)
          self.previousWeightDeltas.append(layerWeightDeltas)
          self.previousBiasDeltas.append(layerBiasDeltas)
        }
    }
}


//MARK: Methods

extension NeuralNetwork {
    
    // Feed the input through the network and return the output
    func feedForward(inputs: [Double], activationFunction: (Double) -> Double) -> [Double] {
        var activations = inputs
        for i in 0..<(layerCount - 1) {
            var newActivations: [Double] = []
            let layerWeights = weights[i]
            let layerBiases = biases[i]
            for j in 0..<layerSizes[i + 1] {
                var activation = layerBiases[j]
                for k in 0..<layerSizes[i] {
                    activation += activations[k] * layerWeights[j][k]
                }
                newActivations.append(activationFunction(activation))
            }
            activations = newActivations
        }
        return activations
    }
    
    
    //Mutate the weights and biases
    mutating func mutate(mutationRate: Double) {
        for i in 0..<layerCount {
            for j in 0..<layerSizes[i] {
                if Double.random(in: 0...1) < mutationRate {
                    biases[i][j] += Double.random(in: -1...1)
                }
            }
        }
        for i in 0..<(layerCount - 1) {
            for j in 0..<layerSizes[i + 1] {
                for k in 0..<layerSizes[i] {
                    if Double.random(in: 0...1) < mutationRate {
                        weights[i][j][k] += Double.random(in: -1...1)
                    }
                }
            }
        }
    }
    
    //train the network
    mutating func backpropagate(inputs: [Double], expectedOutputs: [Double], activationFunction: (Double) -> Double) {
        // Feed the input through the network to get the output
        let outputs = feedForward(inputs: inputs, activationFunction: activationFunction)

        // Calculate the error for each output node
        var outputErrors: [Double] = []
        for i in 0..<layerSizes[layerCount - 1] {
          let output = outputs[i]
          let expectedOutput = expectedOutputs[i]
          outputErrors.append(output * (1 - output) * (expectedOutput - output))
        }

        // Propagate the errors backwards through the network
        for i in (1..<layerCount).reversed() {
          let layerErrors: [Double] = biases[i - 1].enumerated().map { (j, bias) in
            return weights[i - 1][j].enumerated().reduce(0) { (result, kv) in
              let (k, weight) = kv
              return result + outputErrors[j] * weight
            } * activationFunction(outputs[j]) * (1 - activationFunction(outputs[j]))
          }

          // Update the weights and biases based on the errors
          for j in 0..<layerSizes[i] {
            for k in 0..<layerSizes[i - 1] {
              let weightDelta = learningRate * outputErrors[j] * outputs[k] + momentum * previousWeightDeltas[i - 1][j][k]
              weights[i - 1][j][k] += weightDelta
              previousWeightDeltas[i - 1][j][k] = weightDelta
            }
            let biasDelta = learningRate * outputErrors[j] + momentum * previousBiasDeltas[i - 1][j]
            biases[i - 1][j] += biasDelta
            previousBiasDeltas[i - 1][j] = biasDelta
          }

          // Set the errors for the next iteration
          outputErrors = layerErrors
        }
      }

}




//MARK: Activation Functions

extension NeuralNetwork {
    // The ReLU (Rectified Linear Unit) activation function
    func relu(_ x: Double) -> Double {
        return max(0, x)
    }
    
    // The tanh (Hyperbolic Tangent) activation function
    func tanh(_ x: Double) -> Double {
        let expX = exp(x)
        let expNegX = exp(-x)
        return (expX - expNegX) / (expX + expNegX)
    }
    
    // The sigmoid activation function
    func sigmoid(_ x: Double) -> Double {
        return 1 / (1 + exp(-x))
    }
}


//MARK: Custom Mutating Initializer

extension NeuralNetwork {
    init(originalNetwork: NeuralNetwork, mutationRate: Double) {
        self.layerCount = originalNetwork.layerCount
        self.layerSizes = originalNetwork.layerSizes
        self.learningRate = originalNetwork.learningRate
        self.momentum = originalNetwork.momentum

        // Initialize the weights and biases with the values from the original network, but with a probability of mutation
        self.weights = []
        self.biases = []
        self.previousWeightDeltas = []
        self.previousBiasDeltas = []
        for i in 0..<(layerCount - 1) {
          let layerSize = layerSizes[i]
          let nextLayerSize = layerSizes[i + 1]
          var layerWeights: [[Double]] = []
          var layerBiases: [Double] = []
          var layerWeightDeltas: [[Double]] = []
          var layerBiasDeltas: [Double] = []
          for j in 0..<nextLayerSize {
            var nodeWeights: [Double] = []
            var nodeWeightDeltas: [Double] = []
            for k in 0..<layerSize {
              let weight = originalNetwork.weights[i][j][k]
                        if Double.random(in: 0...1) < mutationRate {
                nodeWeights.append(Double.random(in: -1...1))
              } else {
                nodeWeights.append(weight)
              }
              nodeWeightDeltas.append(0)
            }
            layerWeights.append(nodeWeights)
            layerWeightDeltas.append(nodeWeightDeltas)
            let bias = originalNetwork.biases[i][j]
            if Double.random(in: 0...1) < mutationRate {
              layerBiases.append(Double.random(in: -1...1))
            } else {
              layerBiases.append(bias)
            }
            layerBiasDeltas.append(0)
          }
          self.weights.append(layerWeights)
          self.biases.append(layerBiases)
          self.previousWeightDeltas.append(layerWeightDeltas)
          self.previousBiasDeltas.append(layerBiasDeltas)
        }
      }
}



//MARK: Alternative BP function using for loops

//train the network
//    mutating func backpropagate(inputs: [Double], expectedOutputs: [Double]) {//, activationFunction: (Double) -> Double ) {
//        // Feed the input through the network to get the output
//        let outputs = feedForward(inputs: inputs, activationFunction: sigmoid) //activationFunction)
//
//        // Calculate the error for each output node
//        var outputErrors: [Double] = []
//        for i in 0..<layerSizes[layerCount - 1] {
//            let output = outputs[i]
//            let expectedOutput = expectedOutputs[i]
//            outputErrors.append(output * (1 - output) * (expectedOutput - output))
//        }
//
//        // Propagate the errors backwards through the network
//        for i in stride(from: layerCount - 1, through: 1, by: -1) {
//
//            var layerErrors: [Double] = []
//            for j in 0..<layerSizes[i - 1] {
//                var error = 0.0
//                for k in 0..<layerSizes[i] {
//                    error += outputErrors[k] * weights[i - 1][k][j]
//                }
//                let index = i - 1
//                let activationInput = outputs[j] * (1 - sigmoid(outputs[j]))
//                error *= sigmoid(activationInput)
//                layerErrors.append(error)
//            }
//
//
//
//            // Update the weights and biases based on the errors
//            for j in 0..<layerSizes[i] {
//                for k in 0..<layerSizes[i - 1] {
//                    weights[i - 1][j][k] += learningRate * outputErrors[j] * outputs[k] + momentum * previousWeightDeltas[i - 1][j][k]
//                    previousWeightDeltas[i - 1][j][k] = learningRate * outputErrors[j] * outputs[k] + momentum * previousWeightDeltas[i - 1][j][k]
//                }
//                biases[i - 1][j] += learningRate * outputErrors[j] + momentum * previousBiasDeltas[i - 1][j]
//                previousBiasDeltas[i - 1][j] = learningRate * outputErrors[j] + momentum * previousBiasDeltas[i - 1][j]
//            }
//
//            // Set the errors for the next iteration
//            outputErrors = layerErrors
//        }
//
//    }
