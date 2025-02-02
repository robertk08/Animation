//
//  WordEffectView.swift
//  Animation
//
//  Created by Robert Krause on 30.12.24.
//

import SwiftUI

struct WordEffectView: View {
    @State var word = "HYPERPLEXED"
    @State private var animatedWord = "HYPERPLEXED"
    let abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    @State private var tracker = 0.0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            TextField("", text: $word)
                .frame(width: 200)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Text(animatedWord)
                .font(.system(size: 120, design: .monospaced))
                .onTapGesture {
                    startAnimation()
                }
            Spacer()
        }
        .onChange(of: word) { oldValue, newValue in
            animatedWord = newValue.uppercased()
            word = newValue.uppercased()
        }
    }
    
    private func startAnimation() {
        tracker = 0
        animatedWord = word
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            animatedWord = String(word.enumerated().map { index, letter in
                return index < Int(tracker) ? letter : abc.randomElement()!
            })
            
            tracker += 1 / 5
            
            if Int(tracker) > word.count {
                timer.invalidate()
                self.timer = nil
            }
        }
    }
}

#Preview {
    WordEffectView()
}
