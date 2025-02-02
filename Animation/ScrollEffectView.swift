//
//  ContentView.swift
//  Animation
//
//  Created by Robert Krause on 29.12.24.
//

import SwiftUI

struct ScrollEffectView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                RectanglesView()
            }
        }
        
        HStack(spacing: 20) {
            Button {
                // Action for close button
            } label: {
                Circle()
                    .stroke(.foreground, lineWidth: 3)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "xmark")
                            .foregroundStyle(.foreground)
                            .font(.system(size: 20, weight: .bold))
                    )
                    .tint(.primary)
            }

            Button {
                // Action for heart button
            } label: {
                Circle()
                    .stroke(.foreground, lineWidth: 3)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20, weight: .bold))
                    )
                    .tint(.blue)
            }
        }
    }
}

#Preview {
    ScrollEffectView()
}
