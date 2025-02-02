import SwiftUI

struct ImageItem {
    let name: String
    let color: Color
    var isHovered: Bool
}

struct ImageEffectView: View {
    
    @State private var images: [ImageItem] = [
        ImageItem(name: "Image", color: .blue, isHovered: false),
        ImageItem(name: "Image 1", color: .green, isHovered: false),
        ImageItem(name: "Image 2", color: .orange, isHovered: false)
    ]
    
    @State var opacity: [Double] = [1, 1, 1, 1]
    @State var scale: [CGFloat] = [1, 1, 1, 1]
    @State var offset: [CGFloat] = [0, 0, 0, 0]
    @State private var backgroundColor: Color = .black
    @State private var timer1: Timer?
    @State private var timer2: Timer?
    @State private var timer3: Timer?
    @State private var timer4: Timer?
    @State private var globalOffset: CGFloat = 100
    @State private var globalScale: Double = 0.8

    
    private func startHoverAnimation(at index: Int) {
        timer1 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            opacity[0] = 1
            scale[0] = 1
            offset[0] = 0
            withAnimation(.linear(duration: 3)) {
                opacity[0] = 0
                scale[0] = globalScale
                offset[0] = globalOffset
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            
            timer2 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                opacity[1] = 1
                scale[1] = 1
                offset[1] = 0
                withAnimation(.linear(duration: 3)) {
                    opacity[1] = 0
                    scale[1] = globalScale
                    offset[1] = globalOffset
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            timer3 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                opacity[2] = 1
                scale[2] = 1
                offset[2] = 0
                withAnimation(.linear(duration: 3)) {
                    opacity[2] = 0
                    scale[2] = globalScale
                    offset[2] = globalOffset
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
            timer4 = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                opacity[3] = 1
                scale[3] = 1
                offset[3] = 0
                withAnimation(.linear(duration: 3)) {
                    opacity[3] = 0
                    scale[3] = globalScale
                    offset[3] = globalOffset
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(images.indices, id: \.self) { index in
                            ZStack {
                                Image(images[index].name)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: images[index].isHovered ? 290 : 260, height: images[index].isHovered ? 290 : 260)
                                    .cornerRadius(20)
                                    .shadow(color: .primary, radius: images[index].isHovered ? 6 : 2)
                                    .zIndex(9)
                                
                                if images[index].isHovered {
                                    HoverEffectView(
                                        image: images[index],
                                        scale: scale,
                                        opacity: opacity,
                                        offset: offset
                                    )
                                }
                            }
                            .onHover { hover in
                                if !hover {
                                    timer1?.invalidate()
                                    self.timer1 = nil
                                    timer2?.invalidate()
                                    self.timer2 = nil
                                    timer3?.invalidate()
                                    self.timer3 = nil
                                    timer4?.invalidate()
                                    self.timer4 = nil
                                    opacity = [1, 1, 1, 1]
                                    scale = [1, 1, 1, 1]
                                    offset = [0, 0, 0, 0]
                                }
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    images[index].isHovered = hover
                                }
                                
                                if hover {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        backgroundColor = images[index].color
                                    }
                                    startHoverAnimation(at: index)
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        backgroundColor = .black
                                    }
                                }
                            }
                            .padding(.vertical)
                            .frame(width: geometry.size.width / 3)
                        }
                    }
                    .frame(width: geometry.size.width)
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(backgroundColor.opacity(0.25))
    }
}

struct HoverEffectView: View {
        
        var image: ImageItem
        var scale: [CGFloat]
        var opacity: [Double]
        var offset: [CGFloat]
        
        var body: some View {
            ForEach(0..<4) { index in
                ZStack {
                    Image(image.name)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 290 * scale[index], height: 290 * scale[index])
                        .cornerRadius(20)
                        .opacity(opacity[index])
                        .offset(x: offset[index], y: 0)
                        .zIndex(Double(index + 2))

                    Image(image.name)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 290 * scale[index], height: 290 * scale[index])
                        .cornerRadius(20)
                        .opacity(opacity[index])
                        .offset(x: -offset[index], y: 0)
                        .zIndex(Double(index + 1))
                }
            }
        }
    }
#Preview {
    ImageEffectView()
}
