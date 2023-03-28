//
//  MenuInsideMenu.swift
//  Apps
//
//  Created by Владимир on 28.03.2023.
//

import SwiftUI

struct MenuInsideMenu: View {
    @State var shape = "heart"
    @State var opacity = 1.0
    @State var showOpacitySlider = false
    @State var isAnimating = false
    @State var color: Color = .green
    @State var background: String = "pinkToPurple"
    
    var body: some View {
        ZStack {
            switch background {
            case "pinkToPurple":
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 1.00, green: 0.37, blue: 0.55), Color(red: 0.96, green: 0.15, blue: 0.63)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
            case "tealToBlue":
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.00, green: 0.74, blue: 0.83), Color(red: 0.05, green: 0.15, blue: 0.45)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
            case "orangeToYellow":
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 1.00, green: 0.60, blue: 0.00), Color(red: 1.00, green: 0.92, blue: 0.23)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
            default:
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 1.00, green: 0.37, blue: 0.55), Color(red: 0.96, green: 0.15, blue: 0.63)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
            }
            
            if showOpacitySlider {
                VStack {
                    Spacer()
                    
                    Text("Opacity")
                        .font(.title)
                    
                    Slider(value: $opacity, in: 0...1, step: 0.00001)
                        .padding()
                    
                    Button("Done") {
                        withAnimation {
                            showOpacitySlider = false
                        }
                    }
                    
                }
                .foregroundColor(.white)
                .tint(.white)
            }
            VStack(spacing: 20) {
                
                Menu {
                    Menu {
                        Button {
                            withAnimation {
                                background = "tealToBlue"
                            }
                        } label: {
                            Text("teal to blue")
                        }
                        Button {
                            withAnimation {
                                background = "orangeToYellow"
                            }
                        } label: {
                            Text("orange to yellow")
                        }
                        Button {
                            withAnimation {
                                background = "pinkToPurple"
                            }
                        } label: {
                            Text("pink to purple")
                        }
                        
                        
                    } label: {
                        Text("Background color")
                        Image(systemName: "eyedropper.full")
                    }
                    
                    Button {
                        isAnimating.toggle()
                        
                    } label: {
                        Text("Animate")
                    }
                    
                    Button {
                        withAnimation {
                            showOpacitySlider = true
                        }
                    } label: {
                        Text("Opacity")
                    }
                    
                    
                    Menu("Shapes") {
                        Button {
                            shape = "heart"
                        } label: {
                            Image(systemName: "heart.fill")
                            Text("Heart")
                        }
                        
                        Button {
                            shape = "star"
                        } label: {
                            Text("Star")
                            Image(systemName: "star.fill")
                        }
                        
                        Button {
                            shape = "bubble"
                        } label: {
                            Image(systemName: "phone.bubble.left.fill")
                            Text("Bubble")
                        }
                    }
                    
                } label: {
                    ZStack {
                        Group{
                            switch shape {
                            case "heart":
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 200))
                                    .foregroundColor(.white)
                                
                            case "star":
                                Image(systemName: "star.fill")
                                    .font(.system(size: 200))
                                    .foregroundColor(.white)
                                
                            case "bubble":
                                Image(systemName: "phone.bubble.left.fill")
                                    .font(.system(size: 200))
                                    .foregroundColor(.white)
                                
                            default:
                                Circle()
                                    .fill(Color.green.opacity(opacity))
                                    .frame(width: 150, height: 150)
                                
                            }
                        }
                        .opacity(opacity)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        
                        .animation(isAnimating ? Animation.timingCurve(0.2, 0.2, 0.8, 0.8, duration: 1.0).repeatForever(autoreverses: true) : Animation.easeInOut(duration: 0.5), value: isAnimating)
                        if isAnimating {
                            RippleEffect()
                                .opacity(opacity)
                                .foregroundColor(.white)
                                .frame(width: 300, height: 300)
                        }
                    }
                    
                }
            }
            .font(.title)
        }
    }
}

struct RippleEffect: View {
    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0.2
    
    var body: some View {
        Circle()
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: false)) {
                    self.scale = 2
                    self.opacity = 0
                }
            }
    }
}
