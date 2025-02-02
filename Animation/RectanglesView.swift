//
//  ContentView.swift
//  Animation
//
//  Created by Robert Krause on 29.12.24.
//


import SwiftUI

struct RectangleData {
    var color: Color
    var basePosition: CGPoint
    var alternatePosition: CGPoint
    var rotation: (base: Double, alternate: Double)
    var size: CGSize
    var zIndex: Double
    var isSmall: Bool
}

struct RectanglesView: View {
    @State private var tab = false
    private var rectangles: [RectangleData] = []
    private func generateRandomColors() -> [Color] {
        var allColors: [Color] = [
            .red, .green, .blue, .yellow, .orange, .purple, .pink, .brown, .gray, .cyan, .mint, .indigo
        ]
        allColors.shuffle()
        return Array(allColors.prefix(8))
    }
    
    init() {
        let randomColors = generateRandomColors()
        rectangles = [
            RectangleData(color: randomColors[0],
                          basePosition: CGPoint(x: 200, y: -40),
                          alternatePosition: CGPoint(x: 40, y: 20),
                          rotation: (24, 5),
                          size: CGSize(width: 250, height: 350),
                          zIndex: 8,
                          isSmall: false),
            RectangleData(color: randomColors[1],
                          basePosition: CGPoint(x: 80, y: -60),
                          alternatePosition: CGPoint(x: 0, y: 0),
                          rotation: (8, -3),
                          size: CGSize(width: 250, height: 350),
                          zIndex: 6,
                          isSmall: false),
            RectangleData(color: randomColors[2],
                          basePosition: CGPoint(x: -80, y: -60),
                          alternatePosition: CGPoint(x: 10, y: -5),
                          rotation: (-8, 2),
                          size: CGSize(width: 250, height: 350),
                          zIndex: 4,
                          isSmall: false),
            RectangleData(color: randomColors[3],
                          basePosition: CGPoint(x: -200, y: -40),
                          alternatePosition: CGPoint(x: -30, y: 0),
                          rotation: (-24, -1),
                          size: CGSize(width: 250, height: 350),
                          zIndex: 1,
                          isSmall: false),
            RectangleData(color: randomColors[4],
                          basePosition: CGPoint(x: 184, y: -250),
                          alternatePosition: CGPoint(x: 0, y: 0),
                          rotation: (-15, 0),
                          size: CGSize(width: 80, height: 120),
                          zIndex: 7,
                          isSmall: true),
            RectangleData(color: randomColors[5],
                          basePosition: CGPoint(x: 210, y: 190),
                          alternatePosition: CGPoint(x: 0, y: 0),
                          rotation: (15, 0),
                          size: CGSize(width: 80, height: 120),
                          zIndex: 5,
                          isSmall: true),
            RectangleData(color: randomColors[6],
                          basePosition: CGPoint(x: -184, y: -250),
                          alternatePosition: CGPoint(x: 0, y: 0),
                          rotation: (15, 0),
                          size: CGSize(width: 80, height: 120),
                          zIndex: 4,
                          isSmall: true),
            RectangleData(color: randomColors[7],
                          basePosition: CGPoint(x: -210, y: 190),
                          alternatePosition: CGPoint(x: 0, y: 0),
                          rotation: (-15, 0),
                          size: CGSize(width: 80, height: 120),
                          zIndex: 2,
                          isSmall: true)
        ]
    }


    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let centerX = geometry.size.width / 2
                let centerY = geometry.size.height / 2
                
                ForEach(0..<rectangles.count, id: \.self) { index in
                    let rect = rectangles[index]
                    let position = tab
                        ? rect.basePosition
                        : rect.alternatePosition
                    let rotation = tab
                        ? rect.rotation.base
                        : rect.rotation.alternate
                    
                    RoundedRectangle(cornerRadius: rect.isSmall ? 5 : 15, style: .continuous)
                        .frame(width: rect.size.width, height: rect.size.height)
                        .rotationEffect(.degrees(rotation))
                        .foregroundStyle(rect.color)
                        .position(CGPoint(x: centerX + position.x, y: centerY + position.y))
                        .opacity(rect.isSmall ? (tab ? 1 : 0) : 1)
                        .zIndex(rect.zIndex)
                }
            }
            .onTapGesture {
                withAnimation(.snappy(duration: 0.7)) {
                    tab.toggle()
                }
            }
        }
    }
}

#Preview {
    RectanglesView()
}
