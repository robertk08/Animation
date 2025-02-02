import SwiftUI

struct TextEffectView: View {
    let words: [[String]] = [
        ["Hi", "I", "am"],
        ["robert", "and"],
        ["like", "fun"],
        ["animations"]
    ]
    
    let offsets: [CGSize] = [
        CGSize(width: -20, height: -20), CGSize(width: -15, height: 5), CGSize(width: 0, height: -10),
        CGSize(width: 5, height: -20), CGSize(width: 8, height: -20),
        CGSize(width: 10, height: 0), CGSize(width: 10, height: -15),
        CGSize(width: 25, height: -10), CGSize(width: 25, height: 25),
        CGSize(width: 25, height: -15)
    ]
    
    let rotations: [Double] = [
        15, -10, 5,
        10, -5,
        15, -15,
        20, -5,
        20, -5
    ]
    @Namespace private var animationNamespace
    @State private var opacities: [[Double]]
    
    init() {
        _opacities = State(initialValue: Array(repeating: Array(repeating: 0.99, count: 3), count: 4))
    }
    
    var body: some View {
        VStack {
            ForEach(words.indices, id: \.self) { rowIndex in
                HStack {
                    ForEach(words[rowIndex].indices, id: \.self) { wordIndex in
                        if opacities[rowIndex][wordIndex] != 1.0 {
                            ForEach(Array(words[rowIndex][wordIndex].uppercased().enumerated()), id: \.offset) { index, letter in
                                Text(String(letter))
                                    .matchedGeometryEffect(id: "\(words[rowIndex][wordIndex])+\(index)", in: animationNamespace)
                                    .font(.largeTitle)
                                    .opacity(opacities[rowIndex][wordIndex])
                                    .onTapGesture {
                                        for i in 0..<words.count {
                                            for j in 0..<words[i].count {
                                                withAnimation(.snappy(duration: 1, extraBounce: 0)) {
                                                opacities[i][j] = (i == rowIndex && j == wordIndex) ? 1.0 : 0.3
                                                }
                                            }
                                        }
                                    }
                                        
                            }
                        } else {
                            HStack {
                                ForEach(Array(words[rowIndex][wordIndex].uppercased().enumerated()), id: \.offset) { index, letter in
                                    Text(String(letter))
                                        .matchedGeometryEffect(id: "\(words[rowIndex][wordIndex])+\(index)", in: animationNamespace)
                                            .font(.largeTitle)
                                            .rotationEffect(Angle(degrees: rotations[index]))
                                            .offset(offsets[index])
                                            
                                }
                            }
                            .onTapGesture {
                                withAnimation(.snappy(duration: 1)) {
                                    opacities = Array(repeating: Array(repeating: 0.99, count: 3), count: 4)
                                }
                            }
                        }
                        
                        if wordIndex != words[rowIndex].count - 1 {
                            Spacer()
                        }
                    }
                }
            }
        }
        .frame(width: 280)

    }
}

#Preview {
    TextEffectView()
}
