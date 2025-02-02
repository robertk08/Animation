//
//  ContentView.swift
//  Animation
//
//  Created by Robert Krause on 30.12.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Views").font(.headline)) {
                    NavigationLink("Word Effect View", destination: WordEffectView())
                    NavigationLink("Color Effect Grid", destination: ColorEffectView())
                    NavigationLink("Rectangles View", destination: RectanglesView())
                    NavigationLink("Image Effect View", destination: ImageEffectView())
                    NavigationLink("Circle Effect View", destination: CircleEffectView())
                    NavigationLink("Cursor Effect View", destination: CursorFollowView())
                    NavigationLink("Reveal Effect View", destination: RevealEffectView())
                    NavigationLink("Text Effect View", destination: TextEffectView())
                    NavigationLink("Bezier Curve Effect View", destination: Bezier())

                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
