//
//  NN Visualization.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/2/23.
//
//
import SwiftUI

struct Node: View {
  let bias: Double

  var body: some View {
    ZStack {
      // Draw a circle shape
      Circle()
        .fill(bias >= 0 ? Color.green : Color.red)
        .frame(width: 55, height: 55)
        .overlay(
          Text("\(String(format: "%.4f", bias))")
        )
    }
  }
}



struct Layer: View {
  let biases: [Double]

  var body: some View {
    VStack(spacing: 40) {
      // Add a node view for each bias in the layer
      ForEach(0..<biases.count, id: \.self) { i in
        Node(bias: self.biases[i])
      }
    }
  }
}


struct Network: View {
  let network: NeuralNetwork

  var body: some View {
      ZStack {

          HStack(spacing: 50) {
            // Add a layer view for each layer in the network
              ForEach(0..<network.biases.count, id: \.self) { i in
                Layer(biases: self.network.biases[i])
              }

          }
      }
  }
}
//
//
//
//
//
//struct Weight: View {
//
//    var body: some View {
//        Group {
//            ForEach(
//        }
//    }
//}
//
//
//
//
//
//
//struct NetworkView: View {
//  let network: NeuralNetwork
//  let size: CGSize
//
//  var body: some View {
//    VStack {
//      ForEach(0..<network.layerCount, id: \.self) { i in
//        Layer(biases: self.network.biases[i])
//      }
//      Weights(connections: getPositions(size: size))
//    }
//  }
//    func getPositions(size: CGSize) -> [(CGPoint, CGPoint)] {
//        let numLayers = network.layerCount
//        let layerSizes = network.layerSizes
//
//        var positions: [[CGPoint]] = []
//        var xValues: [CGFloat] = []
//        let diffX = size.width / CGFloat(numLayers + 1)
//
//        for index in 1...numLayers {
//            let newValue = CGFloat(index) * diffX
//            xValues.append(newValue)
//        }
//
//        for layerIndex in 0..<numLayers {
//            let yDiff = size.height / CGFloat(layerSizes[layerIndex] + 1)
//            var yValues: [CGFloat] = []
//            for nodeIndex in 1...layerSizes[layerIndex] {
//                let newValue = CGFloat(nodeIndex) * yDiff
//                yValues.append(newValue)
//            }
//            positions.append(yValues.map { y in CGPoint(x: xValues[layerIndex], y: y) })
//        }
//
//        var connections: [(CGPoint, CGPoint)] = []
//        for layerIndex in 0..<(numLayers - 1) {
//            for nodeIndex in 0..<layerSizes[layerIndex] {
//                for nextNodeIndex in 0..<layerSizes[layerIndex + 1] {
//                    connections.append((positions[layerIndex][nodeIndex], positions[layerIndex + 1][nextNodeIndex]))
//                }
//            }
//        }
//
//        return connections
//    }
//
//
//}
