//
//  PongView.swift
//  SwiftSafari
//
//  Created by Tomer Zilbershtein on 1/2/23.
//

import SwiftUI
import Combine



//struct PongView: View {
//    let timer = Timer.publish(
//        every: (1.0 / 60.0),
//        on: .main,
//        in: .common
//    ).autoconnect()
//    
//    @ObservedObject var gc = GameController(dot: Dot(position: Vector(x: 50, y: 70), velocity: Vector(x: 50, y: 50), maxWidth: 500, maxHeight: 500, minTargetDistance: 15, dotSize: 15))
//    
//    var body: some View {
//        ZStack {
//            //PaddleView(paddle: gc.paddle)
//            Color.blue
//            DotView(gc.dot, CGFloat(gc.dot.dotSize))
//        }
//        .onReceive(timer) { _ in
//            gc.update()
//       }
//    }
//}
//
//
//
//class GameController: Identifiable, ObservableObject {
//    let id = UUID()
//    
//    //@Published public var paddle: Paddle
//    @Published public var dot: Dot
//    
//    
//    
//    init(dot: Dot) {
//        self.dot = dot
//    }
//    
//    
//    func update() {
//        dot.update()
//    }
//    
//}
//
//
//
//
//
//class Dot: Identifiable, ObservableObject {
//    public let id = UUID()
//
//    @Published public var position: Vector
//    @Published var velocity: Vector
//    private let maxWidth: Int
//    private let maxHeight: Int
//    private let minTargetDistance: Float
//    let dotSize: Int
//    
//    
//    
//    init(position: Vector, velocity: Vector, maxWidth: Int, maxHeight: Int, minTargetDistance: Float, dotSize: Int) {
//        self.position = Vector(x: position.x, y: position.y)
//        self.velocity = velocity
//        self.maxWidth = maxWidth
//        self.maxHeight = maxHeight
//        self.minTargetDistance = minTargetDistance
//        self.dotSize = dotSize
//    }
//    
//    
//    func update() {
//        //check hitting wall
//        hittingWall()
//        
//        print(" velocity: \(velocity.x) \(velocity.y) position: \(position.x), \(position.y)")
//        
//        // Update the velocity
//        self.velocity.add(Vector(x: 10, y: 10))
//        
//        // Update the position based on the velocity
//        self.position.add(velocity)
//    }
//    
//    func hittingWall() {
//        //left wall
//        if (self.position.x - Float(dotSize)) < 0 {
//            self.velocity.x = -(self.velocity.x)
//        }
//        
//        //right wall
//        else if (self.position.x + Float(dotSize)) > (Float(self.maxWidth)) {
//            self.velocity.x = -(self.velocity.x)
//        }
//        
//        //top wall
//        else if (self.position.y - Float(dotSize)) < 0 {
//            self.velocity.y = -(self.velocity.y)
//        }
//        
//        //bottom wall
//        else if (self.position.y + Float(dotSize)) > Float(self.maxHeight) {
//            self.velocity.y = -(self.velocity.y)
//        }
//    }
//
//}
//
//struct DotView: View {
//    @ObservedObject var dot: Dot
//    let dotSize: CGFloat
//    
//    init(_ dot: Dot, _ size: CGFloat) {
//        self.dot = dot
//        self.dotSize = size
//    }
//    
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .foregroundColor(self.dotColor(dot: dot))
//                .frame(width: self.dotSize, height: self.dotSize)
//                .offset(x: CGFloat(dot.position.x-250), y: CGFloat(dot.position.y-250))
//        }
//    }
//    
//    func dotColor(dot: Dot) -> Color {
//        return .green
//    }
//
//}
//
//
//
//
//
//
//
//
//struct PaddleView: View {
//    @ObservedObject var paddle: Paddle
//    
//    var body: some View {
//        Rectangle()
//            .frame(width: 80, height: 20)
//    }
//}
//
//
//class Paddle: Identifiable, ObservableObject {
//    let id = UUID()
//    let size: CGSize = CGSize(width: 80, height: 20)
//    @Published var location: Vector = Vector(x: 100, y: 100)
//}

