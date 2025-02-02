import SwiftUI

struct Bezier: View {
    @State private var points: [CGSize] = [
        CGSize(width: 50, height: 200),
        CGSize(width: 150, height: 0),
        CGSize(width: 250, height: 700),
        CGSize(width: 400, height: 200),
        CGSize(width: 600, height: 600),
        CGSize(width: 900, height: 1),
        CGSize(width: 1200, height: 500)] //able to be reset
    @State private var circleSize: CGFloat = 20 //changable
    @State private var scales: [Double] = Array(repeating: 1.0, count: 100)
    @State private var movingCircles: [CGSize] = Array(repeating: CGSize.zero, count: 3)
    @State private var timeBetweenLines = 0.00002 //changable
    @State private var timeToDrawLines = 0.001 //changable
    @State private var timeTracker: Double = 0.0
    @State private var tracker = 0
    @State private var drawing = Path()
    @State private var curve = Path()
    @State private var timer: Timer?
    @State private var mode = 1 // changeable: 1 or 2
    @State private var showText: Bool = false //changable
    @State private var showGrid: Bool = false //changable
    @State private var showCircles: Bool = false //changable
    @State private var showDrawing: Bool = false //changable
    @State private var showCurve: Bool = false //changable
    @State private var replacePoints: Bool = false //changable
    @State private var sides: Int = 5 //changable
    @State private var showSettingsSheet = false

    
    var body: some View {
        ZStack {
            VStack {
                Button("Settings") {
                    showSettingsSheet = true
                }
                .sheet(isPresented: $showSettingsSheet) {
                    BezierSettingsSheet(
                        points: $points,
                        circleSize: $circleSize,
                        timeBetweenLines: $timeBetweenLines,
                        timeToDrawLines: $timeToDrawLines,
                        mode: $mode,
                        showText: $showText,
                        showGrid: $showGrid,
                        showCircles: $showCircles,
                        showDrawing: $showDrawing,
                        showCurve: $showCurve,
                        replacePoints: $replacePoints,
                        sides: $sides
                    )
                }
                Button("Reset") {
                    resetAnimations()
                }
                Button("Animate") {
                    animateBezier()
                }
                Spacer()
            }
            .zIndex(1)
            ForEach(0..<points.count - 1, id: \ .self) { index in
                Path { path in
                    path.move(to: CGPoint(x: points[index].width, y: points[index].height))
                    path.addLine(to: CGPoint(x: points[index + 1].width, y: points[index + 1].height))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5]))
                
                if showText {
                    Text(String(format: "%.2f", sqrt(pow(points[index+1].height - points[index].height, 2) + pow(points[index+1].width - points[index].width, 2))))
                        .position(x: (points[index].width + points[index+1].width) / 2, y: (points[index].height + points[index+1].height) / 2)
                        .foregroundColor(.primary)
                }
            }
            
            if showGrid {
                Path { path in
                    path.move(to: CGPoint(x: movingCircles[0].width, y: movingCircles[0].height))
                    path.addLine(to: CGPoint(x: movingCircles[1].width, y: movingCircles[1].height))
                }
                .stroke(Color.teal, style: StrokeStyle(lineWidth: 3))
            }
            
            ForEach(0..<movingCircles.count, id: \ .self) { index in
                if showCircles {
                    Circle()
                        .foregroundStyle(index == 2 ? .orange : .red)
                        .frame(width: circleSize - 10)
                        .position(x: movingCircles[index].width, y: movingCircles[index].height)
                }
            }
            if showDrawing {
                drawing
                    .stroke(Color.teal, lineWidth: 0.5)
                    .contentShape(RoundedRectangle(cornerRadius: 5))
            }
            if showCurve {
                curve
                    .stroke(Color.primary, lineWidth: 1)
                    .contentShape(RoundedRectangle(cornerRadius: 5))
            }
            
            ForEach(0..<points.count, id: \ .self) { index in
                Circle()
                    .stroke(.primary, lineWidth: 5)
                    .frame(width: circleSize, height: circleSize)
                    .scaleEffect(scales[index])
                    .position(x: points[index].width, y: points[index].height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                points[index] = CGSize(width: value.location.x, height: value.location.y)
                                withAnimation { scales[index] = 1.5 }
                                resetAnimations()
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 1)) {
                                    scales[index] = 1.0
                                }
                                animateBezier()
                            }
                    )
            }
        }
        .onAppear {
            if replacePoints{
                points = polygonBezierPoints(center: CGSize(width: 600, height: 400), radius: 100, sides: sides)
            }
            movingCircles[0] = points[0]
            movingCircles[1] = points[1]
            animateBezier()
        }
        .onChange(of: replacePoints) { oldValue, newValue in
            resetAnimations()
            if replacePoints{
                points = polygonBezierPoints(center: CGSize(width: 600, height: 400), radius: 100, sides: sides)
            }
            movingCircles[0] = points[0]
            movingCircles[1] = points[1]
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            Button("Reset") {
                resetAnimations()
            }
        }
    }
    
    private func animateBezier() {
        curve = Path()
        let point1 = CGPoint(x: movingCircles[0].width, y: movingCircles[0].height)
        let point2 = CGPoint(x: movingCircles[1].width, y: movingCircles[1].height)
        
        curve.move(to: point1)
        drawing.move(to: point1)
        drawing.addLine(to: point2)
        
        timer = Timer.scheduledTimer(withTimeInterval: timeBetweenLines, repeats: true) { _ in
            var speedx = (points[tracker+1].width - points[tracker].width) / timeToDrawLines * timeBetweenLines
            var speedy = (points[tracker+1].height - points[tracker].height) / timeToDrawLines * timeBetweenLines
            
            if movingCircles[0].width > points[tracker+1].width {
                speedx = -abs(speedx)
            } else if movingCircles[0].width < points[tracker+1].width {
                speedx = abs(speedx)
            } else {
                speedx = 0
            }
            
            if movingCircles[0].height > points[tracker+1].height {
                speedy = -abs(speedy)
            } else if movingCircles[0].height < points[tracker+1].height {
                speedy = abs(speedy)
            } else {
                speedy = 0
            }
            
            var speedx2 = (points[tracker+2].width - points[tracker+1].width) / timeToDrawLines * timeBetweenLines
            var speedy2 = (points[tracker+2].height - points[tracker+1].height) / timeToDrawLines * timeBetweenLines
            if movingCircles[1].width > points[tracker+2].width {
                speedx2 = -abs(speedx2)
            } else if movingCircles[1].width < points[tracker+2].width {
                speedx2 = abs(speedx2)
            } else {
                speedx2 = 0
            }
            
            if movingCircles[1].height > points[tracker+2].height {
                speedy2 = -abs(speedy2)
            } else if movingCircles[1].height < points[tracker+2].height {
                speedy2 = abs(speedy2)
            } else {
                speedy2 = 0
            }
            
            let t = timeTracker / timeToDrawLines
            let x = pow(1 - t, 2) * points[tracker].width + 2 * (1 - t) * t * points[tracker+1].width + pow(t, 2) * points[tracker+2].width
            let y = pow(1 - t, 2) * points[tracker].height + 2 * (1 - t) * t * points[tracker+1].height + pow(t, 2) * points[tracker+2].height
            
            movingCircles[2] = CGSize(width: x, height: y)
            
            movingCircles[1] = CGSize(width: movingCircles[1].width + speedx2, height: movingCircles[1].height + speedy2)
            
            movingCircles[0] = CGSize(width: movingCircles[0].width + speedx, height: movingCircles[0].height + speedy)
            
            
            
            let point1 = CGPoint(x: movingCircles[0].width, y: movingCircles[0].height)
            let point2 = CGPoint(x: movingCircles[1].width, y: movingCircles[1].height)
            let point3 = CGPoint(x: movingCircles[2].width, y: movingCircles[2].height)
            let point4 = CGPoint(x: points[tracker+mode].width, y: points[tracker+mode].height)
            let point5 = CGPoint(x: points[tracker+2].width, y: points[tracker+2].height)
            
            drawing.move(to: point1)
            drawing.addLine(to: point2)
            
            timeTracker += timeBetweenLines
            
            if timeTracker / timeToDrawLines >= 1 {
                tracker += mode
                timeTracker = 0
                print(tracker)
                movingCircles[0] = points[tracker]
                movingCircles[1] = points[tracker >= points.count - 2 ? tracker : tracker+1]
                curve.addLine(to: point5)
                curve.move(to: point4)
            } else if !(tracker >= points.count - 2) {
                curve.addLine(to: point3)
                
            }
            if tracker >= points.count - 2 {
                resetAnimations()
            }
        }
    }
    
    private func resetAnimations() {
        timer?.invalidate()
        movingCircles[0] = points[0]
        movingCircles[1] = points[1]
        timeTracker = 0
        tracker = 0
        drawing = Path()
    }
    
    func polygonBezierPoints(center: CGSize, radius: CGFloat, sides: Int) -> [CGSize] {
        guard sides >= 3 else { return [] }
        let angleStep = 2 * .pi / CGFloat(sides)
        let cx = center.width
        let cy = center.height
        var points: [CGSize] = []
        
        for i in 0..<sides {
            let angle1 = angleStep * CGFloat(i) - .pi / 2
            let angle2 = angleStep * CGFloat((i + 1) % sides) - .pi / 2
            let start = CGSize(
                width: cx + cos(angle1) * radius,
                height: cy + sin(angle1) * radius
            )
            points.append(start)
            var control = CGSize(
                width: (start.width + cx + cos(angle2) * radius) / 2,
                height: (start.height + cy + sin(angle2) * radius) / 2
            )
            //control = center
            points.append(control)
        }
        points.append(points[0])
        return points
    }
}

#Preview {
    Bezier()
}


struct BezierSettingsSheet: View {
    @Binding var points: [CGSize]
    @Binding var circleSize: CGFloat
    @Binding var timeBetweenLines: Double
    @Binding var timeToDrawLines: Double
    @Binding var mode: Int
    @Binding var showText: Bool
    @Binding var showGrid: Bool
    @Binding var showCircles: Bool
    @Binding var showDrawing: Bool
    @Binding var showCurve: Bool
    @Binding var replacePoints: Bool
    @Binding var sides: Int
    
    var body: some View {
        Form {
            Section(header: Text("General Settings")) {
                Stepper("Circle Size: \(circleSize, specifier: "%.1f")", value: $circleSize, in: 5...50, step: 1)
                Stepper("Time Between Lines: \(timeBetweenLines, specifier: "%.5f")", value: $timeBetweenLines, in: 0.00001...0.01, step: 0.00001)
                Stepper("Time To Draw Lines: \(timeToDrawLines, specifier: "%.3f")", value: $timeToDrawLines, in: 0.0001...1, step: 0.0001)
                Picker("Mode", selection: $mode) {
                    Text("Mode 1").tag(1)
                    Text("Mode 2").tag(2)
                }
            }
            
            Section(header: Text("Visibility")) {
                Toggle("Show Text", isOn: $showText)
                Toggle("Show Grid", isOn: $showGrid)
                Toggle("Show Circles", isOn: $showCircles)
                Toggle("Show Drawing", isOn: $showDrawing)
                Toggle("Show Curve", isOn: $showCurve)
            }
            
            Section(header: Text("Advanced")) {
                Toggle("Replace Points", isOn: $replacePoints)
                Stepper("Sides: \(sides)", value: $sides, in: 3...10)
            }
        }
    }
}
