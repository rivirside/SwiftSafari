import SwiftUI

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
                .offset(x: CGFloat(dot.position.x) - 350, y: CGFloat(dot.position.y) - 350)
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
        
        return .white
    }
}









struct ContentView: View {
    let timer = Timer.publish(
        every: (1.0 / 30.0),
        on: .main,
        in: .common
    ).autoconnect()
    
    @ObservedObject var population = Population(
        populationSize: 1000,
        width: 700,
        height: 700,
        dotSize: 10,
        brainSize: 400,
        minTargetDistance: 5,
        mutationRatio: 0.01
    )
    
    let target = Vector(x: 350, y: 40) //You can cahange this value
    
    var body: some View {
        return ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Rectangle()
                .stroke(lineWidth: CGFloat(5.0))
                .foregroundColor(.white)
                .frame(width: CGFloat(700), height: CGFloat(700))
            Text("Generation \(population.generation)")
            Rectangle() 
                .foregroundColor(.yellow)
                .frame(width: 20, height: 20)
                .offset(x: CGFloat(target.x) - 350, y: CGFloat(target.y) - 350)
            ForEach (population.dots) { (dot: Dot) in
                DotView(dot, 10)
            }
            DotView(population.dots[0], 15)
        }.onReceive(timer) { input in
            if self.population.allDead() {
                self.population.naturalSelection(target: self.target)
            } else {
                self.population.update(target: self.target)
            }
        }
    }
}
