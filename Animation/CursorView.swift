import SwiftUI

struct CursorFollowView: View {
    @State private var cursorPosition: CGPoint = CGPoint(x: 200, y: 200)
    @State private var angle: Double = 0
    @State private var animationDuration: Double = 20
    
    var body: some View {
        ZStack {
            // Background to detect drag gestures
            Color.blue.opacity(0.000001)
                .edgesIgnoringSafeArea(.all)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            cursorPosition = value.location
                        }
                )
            
            // Circle that follows the cursor
            Ellipse()
                .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple, .indigo, .red]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 350, height: 280)
                .rotationEffect(Angle(degrees: angle))
                .position(cursorPosition)
                .animation(.easeInOut(duration: 0.8), value: cursorPosition)
                .blur(radius: 100)
        }
        .onAppear {
            rotateCircle()
        }
    }
    
    private func rotateCircle() {
        withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
            angle += 360
        }
    }
}

#Preview {
    CursorFollowView()
}
