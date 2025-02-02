//
//  Standby.swift
//  Animation
//
//  Created by Robert Krause on 03.01.25.
//

import SwiftUI

struct Standby: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .center, spacing: 60) {
                    HStack(alignment: .center, spacing: 60) {
                        ChargingView(image: "iphone.gen2", charging: true, value: 0.4, width: 35)
                        ChargingView(image: "airpodspro.chargingcase.wireless.fill", charging: false, value: 0.8, width: 65)
                    }
                    HStack (alignment: .center, spacing: 60) {
                        ChargingView(image: "airpods.pro", charging: false, value: 1, width: 70)
                        ChargingView(image: "", charging: false, value: 0.0, width: 0)
                    }
                }
                .frame(width: geometry.size.width / 2, height: geometry.size.height)
                ExtractedView(geometry: geometry)
            }
        }
    }
}

#Preview {
    Standby()
}

struct ChargingView: View {
    var image: String
    var charging: Bool
    var value: Double
    var width: CGFloat
    var body: some View {
        ZStack {
            Circle ()
                .stroke(.white.opacity(0.1),lineWidth: 15)
                .frame(width: 110)
            
            Circle ()
                .trim(from: 0, to: value)
                .stroke(.green, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .rotationEffect (.degrees (-90))
                .frame(width: 110)
            
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: width)
            if charging {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .scaledToFit()
                    .offset(y: -55)
                    .frame(width: 25)
            }
        }
    }
}


struct ExtractedView: View {
    @State private var time: Date = Date()
    @State private var seconds: Int = Calendar.current.component(.second, from: Date())
    var geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            ForEach(0..<60) { i in
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 20, height: 5)
                    .rotationEffect(.degrees(90 + Double(i) * 6))
                    .position(position(for: i, in: geometry.size))
                    .opacity(opacity(for: i, current: seconds))
                    .animation(.smooth(duration: 1), value: opacity(for: i, current: seconds))
            }
            Text(time.formatted(date: .omitted, time: .shortened))
                .font(.system(size: 110, design: .serif))
                .frame(width: geometry.size.width / 2)
                .fontDesign(.default)
                .bold()
        }
        .frame(width: geometry.size.width / 2, height: geometry.size.height)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                time = Date()
                seconds = Calendar.current.component(.second, from: time)
            }
        }
    }
    
    private func position(for second: Int, in size: CGSize) -> CGPoint {
        var second = second
        if second >= 53 {
            second = second - 53
        } else {
            second += 7
        }
        let progress = Double(second) / 60.0
        let sideLength = size.width / 4 - 30
        let center = size.width / 4  + 10
        
        let side = Int(progress * 4)
        let sideProgress = (progress * 4).truncatingRemainder(dividingBy: 1)
        
        switch side {
        case 0: // Top
            return CGPoint(x: center - sideLength + (2 * sideLength * sideProgress) + 10,
                          y:  center - sideLength)
        case 1: // Right
            return CGPoint(x: center + sideLength ,
                          y:  center - sideLength + (2 * sideLength * sideProgress) + 10)
        case 2: // Bottom
            return CGPoint(x: center + sideLength - (2 * sideLength * sideProgress) - 10,
                          y:  center + sideLength)
        default: // Left
            return CGPoint(x: center - sideLength ,
                          y:  center + sideLength - (2 * sideLength * sideProgress) - 10)
        }
    }
    
    private func opacity(for second: Int, current: Int) -> Double {
        var calcualtedNumber = 0
        let difference = current - second
        if difference > 0 {
            calcualtedNumber =  60 - difference
        } else {
            calcualtedNumber =  abs(difference)
        }
        let opacity: Double =  Double(calcualtedNumber) / 60.0
        return opacity
    }
}
