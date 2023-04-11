//
//  Drop.swift
//  Apps
//
//  Created by Владимир on 11.04.23.
//

import SwiftUI

struct Home: View {
    
    @State private var progress: CGFloat = 0.5
    @State private var startAnimation: CGFloat = 0
    
    var body: some View {
        VStack {
            Spacer()
            WaterWaveContainer(progress: $progress, startAnimation: $startAnimation)
                
                .frame(height: 350)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("BG"))
    }
}



struct WaterWaveContainer: View {
    @Binding var progress: CGFloat
    @Binding var startAnimation: CGFloat
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                WaterDropImage()
                WaterWaveOverlay(progress: progress, waveHeight: 0.05, offset: startAnimation)
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .onAppear {
                        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                            startAnimation = size.width
                        }
                    }
            }
        }
    }
}

struct WaterDropImage: View {
    var body: some View {
        Image(systemName: "drop.fill")
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .scaleEffect(x: 1.1, y: 1)
            .offset(y: -1)
    }
}

struct WaterWaveOverlay: View {
    @State var progress: CGFloat
    var waveHeight: CGFloat
    var offset: CGFloat
    
    var body: some View {
        WaterWave(progress: progress, waveHeight: waveHeight, offset: offset)
            .fill(Color.blue)
            .overlay(WaterDropsOverlay())
            .mask(WaterDropMask())
            .overlay(
                HStack {
                    DecreaseButton(progress: $progress)
                    IncrementButton(progress: $progress
                    )}.padding(20).background {
                        Color.white.cornerRadius(30)
                    }.offset(y: -100), alignment: .top)
    }
}

struct WaterDrops: Identifiable, Hashable {
    var id = UUID()
    var size: CGFloat
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
}

struct WaterDropsOverlay: View {
    let waterDrops: [WaterDrops] = [
        WaterDrops(size: 15, x: -20, y: 0, opacity: 0.1),
        WaterDrops(size: 15, x: 40, y: 24, opacity: 0.1),
        WaterDrops(size: 25, x: -30, y: 77, opacity: 0.1),
        WaterDrops(size: 25, x: 50, y: 70, opacity: 0.1),
        WaterDrops(size: 10, x: 40, y: 100, opacity: 0.1),
        WaterDrops(size: 10, x: -40, y: 50, opacity: 0.1)
    ]

    var body: some View {
        ZStack {
            ForEach(waterDrops) { drop in
                Circle()
                    .fill(Color.white.opacity(drop.opacity))
                    .frame(width: drop.size, height: drop.size)
                    .offset(x: drop.x, y: drop.y)
            }
        }
    }
}

struct WaterDropMask: View {
    var body: some View {
        Image(systemName: "drop.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(10)
    }
}

struct IncrementButton: View {
    @Binding var progress: CGFloat
    var body: some View {
        Button {
            progress += 0.1
        } label: {
            Image(systemName: "plus")

        }
    }
}

struct DecreaseButton: View {
    @Binding var progress: CGFloat
    var body: some View {
        Button {
            progress -= 0.1
        } label: {
            Image(systemName: "minus")

        }
    }
}

struct WaterWave: Shape {
    var progress: CGFloat
    var waveHeight: CGFloat
    var offset: CGFloat
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2) {
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
