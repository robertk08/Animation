import SwiftUI
import AVFoundation

struct ModernDesignView: View {
    @State private var isTapped: Bool = false
    @State private var brightness: Double = UIScreen.main.brightness
    @State private var soundVolume: Float = AVAudioSession.sharedInstance().outputVolume
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 32) {
                // 1. Minimalistic Card with Depth and Shadow
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.primary.opacity(0.1))
                    .overlay(
                        VStack {
                            Text("Explore Modern Design")
                                .font(.largeTitle.weight(.bold))
                                .padding(.bottom, 10)
                            Text("Adjust brightness and volume with smooth interactions.")
                                .multilineTextAlignment(.center)
                                .font(.body)
                        }
                        .padding()
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .padding()
                
                // 2. Brightness Control
                HStack {
                    Image(systemName: "sun.min.fill")
                        .foregroundColor(.yellow)
                    Slider(value: $brightness, in: 0...1, step: 0.01)
                        .onChange(of: brightness) { newValue in
                            UIScreen.main.brightness = CGFloat(newValue)
                        }
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                }
                .padding(.horizontal)
                
                // 3. Sound Volume Control
                HStack {
                    Image(systemName: "speaker.fill")
                    Slider(value: Binding(
                        get: { soundVolume },
                        set: { newValue in
                            soundVolume = newValue
                            setVolume(newValue)
                        }
                    ), in: 0...1, step: 0.01)
                    Image(systemName: "speaker.wave.3.fill")
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    private func setVolume(_ volume: Float) {
        // Volume setting for educational purposes
        // Direct control of system volume is not allowed for security reasons
    }
}

#Preview {
    ModernDesignView()
}
