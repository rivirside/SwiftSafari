//
//  FieldView.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/5/23.
//

import SwiftUI

struct FieldView: View {
    let timer = Timer.publish(
        every: (1.0 / 60.0),
        on: .main,
        in: .common
    ).autoconnect()
    
    @State var counter = 0
    
    @ObservedObject var population: Population = Population(
        numMice: 1,
        numBerries: 1,
        width: 500,
        height: 500,
        minTargetDistance: 10
    )
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Rectangle()
                .stroke(lineWidth: CGFloat(5.0))
                .foregroundColor(.white)
                .frame(
                    width: CGFloat(population.width),
                    height: CGFloat(population.height)
                )
            ForEach(population.mice) { (mouse: Mouse) in
                MouseView(mouse, 10)
            }
            ForEach(population.berries) { (berry: Berry) in
                BerryView(berry, 10)
            }
            Color(.clear)
        }
        .onReceive(timer) { input in
            print("x: \(population.mice[0].position.x), y: \(population.mice[0].position.y)")
            if self.population.allMiceDead() {
                self.population.nextGeneration()
            } else {
                self.population.update()
                population.counter += 1
//                if population.counter >= 1000 {
//                    population.exterminateMice()
//                    population.counter = 0
//                } else {
//                    self.population.update()
//                    population.counter += 1
//                }
            }
        }
    }
}

struct FieldView_Previews: PreviewProvider {
    static var previews: some View {
        FieldView()
    }
}
