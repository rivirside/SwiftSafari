////
////  DataStorage.swift
////  SwiftSafari
////
////  Created by Tomer Zilbershtein on 1/1/23.
////https://serialcoder.dev/text-tutorials/macos-tutorials/save-and-open-panels-in-swiftui-based-macos-apps/
//
//import SwiftUI
//
//struct SaveOpenView: View {
//    //@ObservedObject var population: Population
//    var body: some View {
//        VStack {
//            Button {
//                showOpenPanel()
//            } label: {
//                Text("Open")
//            }
//            Button {
//                showSavePanel()
//            } label: {
//                Text("Save")
//            }
//        }
//    }
//    func showOpenPanel() -> URL? {
//        let openPanel = NSOpenPanel()
//        openPanel.allowedContentTypes = [.text]
//        openPanel.allowsMultipleSelection = false
//        openPanel.canChooseDirectories = false
//        openPanel.canChooseFiles = true
//        let response = openPanel.runModal()
//        return response == .OK ? openPanel.url : nil
//    }
//    
//    func showSavePanel() -> URL? {
//        let savePanel = NSSavePanel()
//        savePanel.allowedContentTypes =  [.text]
//        savePanel.canCreateDirectories = true
//        savePanel.isExtensionHidden = false
//        savePanel.title = "Save best network"
//        savePanel.message = "Choose a folder and a name to store the weights and biases."
//        savePanel.nameFieldLabel = "File name:"
//        
//        let response = savePanel.runModal()
//        return response == .OK ? savePanel.url : nil
//    }
//    
//    func encodeToString(network: NeuralNetwork) {
//        // Convert the weights and biases to a string representation
//        let weightsString = network.weights.map { layer in
//          layer.map { nodeWeights in
//            nodeWeights.map { String($0) }.joined(separator: ",")
//          }.joined(separator: ";")
//        }.joined(separator: "|")
//        let biasesString = network.biases.map { layer in
//          layer.map { String($0) }.joined(separator: ",")
//        }.joined(separator: "|")
//        let networkString = "\(weightsString)|\(biasesString)"
//
//        // Write the network string to a file
//        if let url = showSavePanel() {
//          do {
//            try networkString.write(to: url, atomically: true, encoding: .utf8)
//          } catch {
//            print("Error saving file: \(error)")
//          }
//        }
//
//    }
//}
