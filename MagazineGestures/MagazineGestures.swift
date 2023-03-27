//
//  MagazinePinch.swift
//  Apps
//
//  Created by Владимир on 27.03.2023.
//

import SwiftUI

struct MagazineGestures: View {
    @State private var aimate: Bool = false
    @State private var scaleFactor: CGFloat = 1
    @State private var offsetImage: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let covers: [Cover] = [
        Cover(id: 1, imageName: "Image1"),
        Cover(id: 2, imageName: "Image2"),
        Cover(id: 3, imageName: "Image3")
      ]
    @State private var coverIndex: Int = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                Image(currentCover())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.5), radius: 20, x: 10, y: 10)
                    .animation(.easeInOut(duration: 1), value: aimate)
                    .offset(x: offsetImage.width, y: offsetImage.height)
                    .scaleEffect(scaleFactor)
                    .onTapGesture(count: 2, perform: {
                        if scaleFactor == 1 {
                            withAnimation(.spring()) {
                                scaleFactor = 2
                            }
                        } else {
                            resetState()
                        }
                    })
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    offsetImage = value.translation
                                }
                            }
                            .onEnded { _ in
                                if scaleFactor <= 1 {
                                    resetState()
                                }
                            }
                    )
                
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if scaleFactor >= 1 && scaleFactor <= 5 {
                                        scaleFactor = value
                                    } else if scaleFactor > 5 {
                                        scaleFactor = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if scaleFactor > 5 {
                                    scaleFactor = 5
                                } else if scaleFactor <= 1 {
                                    resetState()
                                }
                            }
                    )
            }
            .onAppear(perform: {
                aimate = true
            })
            
            .overlay(
                Group {
                    HStack(spacing: 15) {
                        Button {
                            withAnimation(.spring()) {
                                if scaleFactor > 1 {
                                    scaleFactor -= 0.5
                                    
                                    if scaleFactor <= 1 {
                                        resetState()
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 28))
                            
                        }
                        
                        Button {
                            resetState()
                        } label: {
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle")
                                .font(.system(size: 28))
                        }
                        
                        Button {
                            withAnimation(.spring()) {
                                if scaleFactor < 5 {
                                    scaleFactor += 0.5
                                    
                                    if scaleFactor > 5 {
                                        scaleFactor = 5
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 28))
                        }
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background {
                        Color.black.cornerRadius(20).opacity(0.1)
                    }
                    .padding(2)
                    
                }
                ,alignment: .bottom
            )
            .overlay(
                HStack(spacing: 12) {
                    ForEach(covers) { item in
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(coverIndex == item.id ? 1 : 0.5)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture(perform: {
                                withAnimation {
                                    aimate = true
                                    coverIndex = item.id
                                }
                            })
                    }
                }
                , alignment: .top
            )
        }
        .navigationViewStyle(.stack)
    }
    
    private func resetState() {
        return withAnimation(.spring()) {
            scaleFactor = 1
            offsetImage = .zero
        }
    }
    
    private func currentCover() -> String {
        return covers[coverIndex - 1].imageName
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineGestures()
    }
}

struct Cover: Identifiable {
  let id: Int
  let imageName: String
}
