import SwiftUI

struct ContentView: View {
    @State var gameOn: Bool = true
    var body: some View {
        if gameOn {
            Game().frame(width: 500, height: 500)
        } else {
            LoadingScreen(gameOn: $gameOn)
        }
        
    }
}

struct LoadingScreen: View {
    @Binding var gameOn: Bool
    
    var body: some View {
        Text("Placeholder")
    }
}

struct Game: View{
    
    let timer = Timer.publish(
        every: (1.0 / 60.0),
        on: .main,
        in: .common
    ).autoconnect()
    
    @State var counter = 0
    
    @ObservedObject var population: Population = Population(
        numDots: 50,
        targetPosition: Vector(x: 300, y: 300),
        width: 500,
        height: 500,
        dotSize: 10,
        minTargetDistance: 20
    )
    
    var body: some View {
        ZStack(){
            Color.black.edgesIgnoringSafeArea(.all)
            Circle()
                .stroke(lineWidth: CGFloat(5.0))
                .foregroundColor(.blue)
                .frame(width: 20, height: 20)
                .position(x: 100, y: 100)
            Rectangle()
                .stroke(lineWidth: CGFloat(5.0))
                .foregroundColor(.white)
                .frame(
                    width: CGFloat(population.width),
                    height: CGFloat(population.height)
                )
            
            VStack {
                HStack {
                    VStack {
                        Text("Generation \(population.generation)")
                        Text("Best Score: \(population.bestScore.formatted())")
                    }
                    Spacer()
                    VStack {
                        Text("Population: \(population.dots.count)")
                        Text("D/S: \(population.dead) / \(population.winners)")
                        
                    }
                    Spacer()
                    VStack {
                        Text("Timer: \(counter)")
                        Button {
                            for dot in population.dots {
                                dot.dead = true
                            }
                        } label: {
                            Text("kill")
                        }
                    }
                    
                    
                    
                }
                Spacer()
            }.offset(y: -80)
            Circle()
                .frame(width: 20, height: 20)
                .position(
                    x: CGFloat(population.targetPosition.x),
                    y: CGFloat(population.targetPosition.y)
                )
                .foregroundColor(.yellow)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.population.targetPosition = Vector(
                                x: Float(gesture.location.x),
                                y: Float(gesture.location.y)
                            )
                        }
                )
            ForEach (population.dots) { (dot: Dot) in
                DotView(dot, CGFloat(self.population.dotSize))
            }
            //DotView(population.dots[0], 15)
        }
        .onReceive(timer) { input in
            if self.population.allDead() {
                population.selectNextGeneration()
                resetView()
            } else {
                if counter >= 1000 {
                    for dot in population.dots {
                        dot.dead = true
                    }
                    counter = 0
                } else {
                    self.population.update(
                        target: population.targetPosition)
                    counter += 1
                }
                
            }
        }
    }
    
    func resetView() {
        population.resetView()
    }
    
}




struct DotView: View {
    @ObservedObject var dot: Dot
    let dotSize: CGFloat
    
    init(_ dot: Dot, _ size: CGFloat) {
        self.dot = dot;
        self.dotSize = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(self.dotColor(dot: dot))
                .frame(width: self.dotSize, height: self.dotSize)
                .offset(x: CGFloat(dot.position.x-250), y: CGFloat(dot.position.y-250))
        }
    }
    
    func dotColor(dot: Dot) -> Color {
        if dot.success {
            return .green
        }
        
        if dot.dead {
            return .red
        }
        
        if dot.champion {
            return .blue
        }
        
        return .purple
    }
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
