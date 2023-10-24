//
//  SIR Model.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 10/23/23.
//

import Foundation

import SwiftUI

struct SIRModelView: View {
    @State private var susceptibleCount = 1000
    @State private var infectedCount = 0
    @State private var recoveredCount = 0
    
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            HStack {
                PopulationView(label: "S", count: $susceptibleCount)
                PopulationView(label: "I", count: $infectedCount)
                PopulationView(label: "R", count: $recoveredCount)
            }
            
            Spacer()
        }
        .onAppear {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                // Simulate the spread and recovery of the disease
                let newInfections = Int(Double(susceptibleCount) * 0.1)
                let newRecoveries = Int(Double(infectedCount) * 0.05)
                self.susceptibleCount -= newInfections
                self.infectedCount += newInfections - newRecoveries
                self.recoveredCount += newRecoveries
            }
        }
        .onDisappear {
            self.timer?.invalidate()
        }
    }
}

struct PopulationView: View {
    let label: String
    @Binding var count: Int
    
    var body: some View {
        VStack {
            Text(label)
                .font(.largeTitle)
            Rectangle()
                .fill(getColor(for: label))
                .frame(width: 100, height: 100)
                .opacity(getOpacity())
            Text("Count: \(count)")
        }
    }
    
    func getColor(for label: String) -> Color {
        switch label {
        case "S": return .green
        case "I": return .red
        case "R": return .blue
        default: return .black
        }
    }
    
    func getOpacity() -> Double {
        return count == 0 ? 0 : Double(count) / 1000.0
    }
}
