
import Foundation
import SwiftUI
import Combine

class Vector: ObservableObject {
    @Published public var x: Float
    @Published public var y: Float
    
    init(x: Float, y: Float) {
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
    
    func limit(_ max: Float) {
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
    
    func distance(_ other: Vector) -> Float {
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












// Our brave hero, the dot - on an epic adventure to reach the target
class Dot: Identifiable, ObservableObject {
    public let id = UUID()
    
    // Who's alive, who's dead, who's the champion, and who's a success? Our dot, of course!
    @Published public var dead: Bool
    @Published public var success: Bool
    @Published public var champion: Bool
    
    // This dot's personal space, moving around in the world
    @Published public var position: Vector
    @Published public var score: Float = 0
    @Published public var neuralNetwork: NeuralNetwork
    
    // The key to a dot's heart: its movement properties
    @Published var direction: Vector
    @Published var acceleration: Vector
    @Published var velocity: Vector
    @Published var history: Double = 0
    
    // Energy and speed multiplier properties
    @Published public var energy: Float = 100.0
    @Published public var speedMultiplier: Float = 1.0
    
    // The dot's knowledge about the berries
    @Published public var berries: [Berry]
    
    // This dot likes to know its limits - boundaries, darling!
    private let maxWidth: Int
    private let maxHeight: Int
    private let minTargetDistance: Float
    let dotSize: Int
    
    // A little constructor for the little dot that could
    init(dead: Bool, success: Bool, champion: Bool, position: Vector, neuralNetwork: NeuralNetwork, direction: Vector, acceleration: Vector, velocity: Vector, maxWidth: Int, maxHeight: Int, minTargetDistance: Float, dotSize: Int, berries: [Berry], energy: Float = 100.0, speedMultiplier: Float = 1.0) {
        self.dead = dead
        self.success = success
        self.champion = champion
        self.position = Vector(x: position.x, y: position.y)
        self.neuralNetwork = neuralNetwork
        self.direction = Vector(x: 0, y: 0)
        self.acceleration  = Vector(x: 0, y: 0)
        self.velocity = velocity
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.minTargetDistance = minTargetDistance
        self.dotSize = dotSize
        self.berries = berries
        self.energy = energy
        self.speedMultiplier = speedMultiplier
    }
    
    // Time to get a good score, gotta catch 'em all!
    func updateScore(target: Vector) {
        self.score = 1.0 / self.position.distance(target)
    }
    
    // Life is like a box of chocolates; you never know when you'll update your position
    func update(target: Vector) {
        // Check if the dot has reached the target
        if self.position.distance(target) < minTargetDistance {
            self.success = true
            self.dead = true
            return
        }
        
        // Check if the dot has gone out of bounds or run out of energy
        if outBounds() || self.energy <= 0 {
            self.dead = true
            return
        }
        
        // Calculate the inputs for the neural network
        let inputs = [
            self.position.x ,
            self.position.y ,
            self.velocity.x,
            self.velocity.y,
            self.acceleration.x,
            self.acceleration.y,
            target.x,
            target.y
        ] + berries.map { $0.position.x } + berries.map { $0.position.y }
        
        // Calculate the output of the neural network
        let outputs = self.neuralNetwork.predict(inputs: inputs)
        // Update the acceleration based on the output of the neural network
        self.acceleration = Vector(
            x: tanh(outputs[0]),
            y: tanh(outputs[1])
        )
        
        // Update the velocity based on the acceleration
        self.velocity.add(Vector(x: acceleration.x, y: acceleration.y))
        
        // Limit the velocity to the maximum velocity
        self.velocity.limit(5 * speedMultiplier)
        
        // Update the position based on the velocity
        self.position.add(velocity)
        
        // Update the energy based on the velocity and speed multiplier
        self.energy -= self.velocity.magnitude() * speedMultiplier
        
        // Check for nearby berries and consume them if close enough
        for (index, berry) in berries.enumerated() {
            if self.position.distance(berry.position) < Float(dotSize + berry.berrySize) {
                self.energy += berry.energyValue
                berries.remove(at: index)
                break
            }
        }
    }
    
    // Curiosity killed the cat
    // Curiosity killed the cat, but satisfaction brought it back! Are we out of bounds yet?
    func outBounds() -> Bool {
        var bool = false
        if self.position.x < 0 {
            bool = true
        } else if self.position.x > (Float(self.maxWidth)) {
            bool = true
        } else if self.position.y < 0 {
            bool = true
        } else if self.position.y > Float(self.maxHeight) {
            bool = true
        }
        return bool
    }
    
    // Once upon a time, there was a dot that wanted to update its history
    func updateHistory(target: Vector) {
        let dotX = Double(position.x)
        let dotY = Double(position.y)
        let targetX = Double(target.x)
        let targetY = Double(target.y)
        
        // The one calculation to rule them all
        let score = sqrt((dotX-targetX)*(dotX-targetX)+(dotY-targetY)*(dotY-targetY))
        history += score
        if success {
            // Our mighty hero has succeeded; let's cut the history in half!
            history /= 2
        }
    }
    
    // This dot has a short memory; it can clear its history just like that!
    func clearHistory() {
        history = 0
    }
}































//MARK: Population
class Population: ObservableObject {
    @Published public var dots: [Dot]
    @Published public var targetPosition: Vector
    @Published public var generation: Int = 0
    @Published public var bestScore: Float = 0
    @Published public var counter = 0
    
    @Published public var dead: Int = 0
    @Published public var winners: Int = 0
    
    public let survivalRate = 0.5
    public let width: Int
    public let height: Int
    public let dotSize: Int
    public let minTargetDistance: Float
    public let mutationRate: Float = 0.005
    
    init(numDots: Int, targetPosition: Vector, width: Int, height: Int, dotSize: Int, minTargetDistance: Float) {
        self.dots = []
        
        
        self.targetPosition = targetPosition
        self.width = width
        self.height = height
        self.dotSize = dotSize
        self.minTargetDistance = minTargetDistance
        
        
        for _ in 0..<numDots {
            // Initialize the dot with a neural network
            
            let dot = Dot(
                dead: false,
                success: false,
                champion: false,
                position: Vector(x: 100, y: 100),
                neuralNetwork: NeuralNetwork(
                    inputNodes: 8,
                    hiddenNodes: 20,
                    outputNodes: 2),
                direction: Vector(
                    x: 10,
                    y: 10),
                acceleration: Vector(
                    x: 0,
                    y: 0),
                velocity: Vector(
                    x: 0,
                    y: 0),
                maxWidth: width,
                maxHeight: height,
                minTargetDistance:
                    minTargetDistance,
                dotSize: dotSize
            )
            self.dots.append(dot)
            
        }
    }
    
    func update(target: Vector) {
        dead = 0
        winners = 0
        
        //iterate over dots with dot.update for the target location
        for dot in self.dots {
            if dot.dead {
                dead += 1
            }
            if dot.success  {
                winners += 1
            }
            dot.updateHistory(target: target)
            dot.update(target: target)
        }
    }
    
    func allDead() -> Bool {
        //check for a pulse
        for dot in self.dots {
            if !dot.dead {
                return false
            }
        }
        return true
    }
    
    
    
    func resetView() {
        // Reset the status of the dots
        var holder = 0
        for dot in self.dots {
            if dot.success {
                holder += 1
            }
            dot.dead = false
            dot.success = false
            dot.position = Vector(x: 100, y: 100)
            
        }
        
        if generation < 100 {
            targetPosition = randomVectorIn(minX: Float(width)/4, maxX: Float(width)*3/4, minY: Float(height)/4, maxY: Float(height)*3/4)
        } else if generation < 500 {
            targetPosition = randomVectorIn(minX: Float(width)/6, maxX: Float(width)*5/6, minY: Float(height)/6, maxY: Float(height)*5/6)
        } else {
            targetPosition = randomVectorIn(minX: Float(width)/10, maxX: Float(width)*9/10, minY: Float(height)/10, maxY: Float(height)*9/10)
        }
        
        if Float(holder) > bestScore {
            bestScore = Float(holder)
        }
        self.counter = 0
        generation += 1
    }
    
    
    func selectNextGeneration() {
        print("selectNextGen")
        sortDots()
        //setupNext()
        selecction2()
    }
    
    func sortDots() {
        self.dots.sort { (dot1, dot2) -> Bool in
            if dot1.success && !dot2.success {
                return true
            } else if !dot1.success && dot2.success {
                return false
            } else {
                return dot1.score > dot2.score
            }
        }
    }
    
    func getEasyTarget() {
        let x = Double.random(in: 0...10)
        let y = Double.random(in: 0...10)
        
        let vector = Vector(x: Float(x), y: Float(y))
        
        targetPosition.add(vector)
    }
    
    func randomVectorIn(minX: Float, maxX: Float, minY: Float, maxY: Float) -> Vector {
        let x = Float.random(in: minX...maxX)
        let y = Float.random(in: minY...maxY)
        return Vector(x: x, y: y)
    }
    
    
    func getRandomTarget() -> Vector {
        let x = Double.random(in: 0.0...Double(width))
        let y = Double.random(in: 0.0...Double(height))
        
        let position = Vector(x: Float(x), y: Float(y))
        return position
    }
    
    
    
    func countSuccessfulDots() -> Int {
        return dots.reduce(0) { (accumulator, dot) in
            if dot.success {
                return accumulator + 1
            } else {
                return accumulator
            }
        }
    }
    
    
    func mutate() {
        print("mutate")
        for dot in dots {
            var network = dot.neuralNetwork
            network.mutate(mutationRate: 1, minWeight: -1, maxWeight: 1)
            dot.neuralNetwork = network
        }
    }
    
    func makeFirst() {
        print("makeFirst")
        for dot in dots[1..<dots.count] {
            dot.neuralNetwork = dots[0].neuralNetwork
        }
    }
    
    func selection() {
        print("selection")
        var index = 0
        for dot in dots[0..<dots.count/2] {
            var network = dot.neuralNetwork
            network.mutate(mutationRate: Double(mutationRate), minWeight: -1, maxWeight: 1)
            dots[index + dots.count/2].neuralNetwork = network
            index += 1
        }
    }
    
    func selecction2() {
        print("selection2")
        historySort()
        
        let startIndex = dots.count / 2
        let endIndex = dots.count - 1
        
        var index = 0
        
        for dot in dots[startIndex...endIndex] {
            
            var network = dots[index].neuralNetwork
            network.mutate(mutationRate: Double(mutationRate), minWeight: -1, maxWeight: 1)
            dot.neuralNetwork = network
            index += 1
        }
        checkScores()
        clearDotHistory()
        
    }
    
    func setupNext() {
        sortDots()
        let winners = countSuccessfulDots()
        
        for dot in dots[winners..<dots.count] {
            
            var network = dots[0].neuralNetwork
            network.mutate(mutationRate: Double(mutationRate), minWeight: -1, maxWeight: 1)
            
            dot.neuralNetwork = network
            
        }
    }
    
    func historySort() {
        dots.sorted { $0.history > $1.history }
    }
    
    func clearDotHistory() {
        for dot in dots {
            dot.clearHistory()
        }
    }
    
    func checkScores() {
        var scores: [Double] = []
        for dot in dots[0..<dots.count] {
            scores.append(dot.history)
        }
        print(scores)
    }
    
    
}

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
    
    
    func save(to fileURL: URL) throws {
        // Serialize the weights and biases to a Data object
        let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
        
        // Write the Data object to the specified file URL
        try data.write(to: fileURL)
    }
    
    
    
}
