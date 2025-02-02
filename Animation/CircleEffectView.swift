import SwiftUI

struct CircleEffectView: View {
    @State private var angles: [Double] = Array(repeating: Double.pi, count: 20)
    @AppStorage("timerInSeconds") var timerInSeconds: Double = 20
    @AppStorage("pairsOf") var pairsOf: Double = 2
    @AppStorage("rotations") var rotations: Double = 10
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Slider(value: $timerInSeconds, in: 1...900, step: 1)
                        .tint(.green)
                    Text("\(Int(timerInSeconds))")
                        .font(.title)
                }
                HStack {
                    Slider(value: $pairsOf, in: 1...20, step: 1)
                        .tint(.orange)
                    Text("\(Int(pairsOf))")
                        .font(.title)
                }
                HStack {
                    Slider(value: $rotations, in: 0...100, step: 1)
                        .tint(.cyan)
                    Text("\(Int(rotations))")
                        .font(.title)
                }
                Text("Minumum: \(Int(20 / pairsOf))")
            }
            
            ZStack {
                let centerX = geometry.size.width / 2
                let centerY = geometry.size.height / 2 + 370
                
                Rectangle()
                    .frame(width: centerX * 2 - 360, height: 3)
                    .position(x: centerX, y: centerY)
                
                ForEach(0..<20, id: \.self) { index in
                    let radius: Double = 730 / Double(20) * Double(index + 1) / 2
                    
                    let oneLoop =  2 * Double.pi
                    let velocity = Double(Int(rotations+1 - Double(index + 1) / pairsOf)) * oneLoop / timerInSeconds

                    Circle()
                        .trim(from: 0.5, to: 1)
                        .fill(.clear)
                        .stroke(Color.primary, lineWidth: 2)
                        .frame(width: radius * 2)
                        .position(x: centerX, y: centerY)
                    
                    Circle()
                        .fill(.primary)
                        .frame(width: 10)
                        .position(
                            x: radius * cos(angles[index]) + centerX,
                            y: radius * sin(angles[index]) + centerY < centerY ?
                                radius * sin(angles[index]) + centerY :
                                -1 * (radius * sin(angles[index])) + centerY
                        )
                        .onAppear {
                            startAnimating(index: index, speedMultiplier: velocity)
                        }
                }
            }
        }
        .padding()
    }
    
    func startAnimating(index: Int, speedMultiplier: Double) {
         Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if angles[index] >= 2 * Double.pi { angles[index] = 0 }
            angles[index] += (speedMultiplier / 100.0)
        }
    }
}

#Preview {
    CircleEffectView()
}
