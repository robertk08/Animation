import SwiftUI

struct ColorEffectView: View {
    @State private var colors: [[Color]]
    @State private var opacity: [[Double]]
    
    init() {
        // Initialize the colors and opacity arrays
        let allColors: [Color] = [
            .red, .green, .blue, .yellow, .orange, .purple, .pink, .gray, .cyan, .mint, .indigo
        ]
        let randomColors = (0..<50).map { _ in
            (0..<50).map { _ in allColors.randomElement() ?? .blue }
        }
        _colors = State(initialValue: randomColors)
        _opacity = State(initialValue: Array(repeating: Array(repeating: 0.0, count: 50), count: 50))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.black, .black, .clear, .clear, .clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .zIndex(1)
            .allowsHitTesting(false)
            
            VStack(spacing: 0) {
                ForEach(0..<50, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<50, id: \.self) { column in
                            ZStack {
                                Rectangle()
                                    .fill(colors[row][column])
                                    .frame(width: 50, height: 50)
                                    .opacity(opacity[row][column])
                                    .onHover { hover in
                                        withAnimation(.easeOut(duration: 1)) {
                                            opacity[row][column] = hover ? 1 : 0.0
                                        }
                                    }
                                
                                if row % 2 == 0 && column % 2 == 0 {
                                    Image(systemName: "xmark")
                                        .bold()
                                        .rotationEffect(.degrees(45))
                                        .font(.system(size: 10))
                                        .padding(.trailing, 50)
                                        .padding(.bottom, 50)
                                }
                                
                                Rectangle()
                                    .stroke(Color.gray, lineWidth: 1)
                                    .opacity(0.6)
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .frame(width: 50, height: 50)
                    }
                }
            }
            .rotation3DEffect(
                .degrees(15),
                axis: (x: 40, y: -5, z: 15),
                perspective: 16
            )
        }
    }
}

#Preview {
    ColorEffectView()
}
