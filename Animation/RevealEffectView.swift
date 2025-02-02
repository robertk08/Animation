import SwiftUI

struct RevealEffectView: View {
    @State private var sliderValue: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                RoundedRectangle(cornerRadius: 60)
                    .fill(.white.opacity(0.3))
                    .frame(width: 300, height: 300)
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 5, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 60)
                            .stroke(Color.black.opacity(0.1), lineWidth: 2)
                            .blur(radius: 2)
                            .offset(x: 2, y: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    )
                    .overlay(
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .opacity((0.5 - sliderValue))
                            .foregroundStyle(.white)
                    )
                    .overlay(
                        ZStack {
                            Image("Image")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(60)
                                .clipped()
                                .opacity(sliderValue)
                                .blur(radius: (((sliderValue - 1 ) * -1) * 50), opaque: false)
                                .animation(.easeInOut(duration: 1.8), value: sliderValue)
                            Color.clear
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let locationX = value.location.x
                                            sliderValue = max(0, min(locationX / 600, 1))
                                        }
                                )
                        }
                    )
                    .rotation3DEffect(
                        .degrees(Double(sliderValue * 5) - 2.5),
                        axis: (x: 1, y: 0, z: 0)
                    )
            }
        }
    }
}

struct FullScreenSliderView_Previews: PreviewProvider {
    static var previews: some View {
        RevealEffectView()
    }
}
