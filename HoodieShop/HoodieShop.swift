//
//  ContentView.swift
//  Apps
//
//  Created by Владимир on 26.03.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
            .statusBarHidden()
    }
}


struct MainView: View {
    @State var productImage: String = "blue"
    @State var isFavorite: Bool = false
    @State var price: Int = 99
    @State var numberOfItems = 1
    @State private var slideOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack {
                HStack{
                    Button {
                        
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                    Spacer()
                    HStack {
                        Text("")
                            .foregroundColor(.white)
                        Button {
                            
                        } label: {
                            Image(systemName: "cart.circle.fill")
                        }
                    }
                    
                }
                .foregroundColor(Color("CustomColorPurple"))
                .padding()
                .font(.largeTitle)
                Spacer()
                VStack{
                    Image(productImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width)
                }
                
                HStack {
                    Button {
                        withAnimation(.spring())  {
                            productImage = "red"
                        }
                    } label: {
                        Image(systemName: "circle.fill")
                    }
                    .scaleEffect(productImage == "red" ? 1.2 : 1.0)
                    .foregroundColor(Color("red1"))
                    Button {
                        withAnimation(.easeInOut)  {
                            productImage = "blue"
                        }
                    } label: {
                        Image(systemName: "circle.fill")
                    }
                    .scaleEffect(productImage == "blue" ? 1.2 : 1.0)
                    .foregroundColor(Color("blue1"))
                    Button {
                        withAnimation(.easeInOut)  {
                            productImage = "purple"
                        }
                    } label: {
                        Image(systemName: "circle.fill")
                    }
                    .scaleEffect(productImage == "purple" ? 1.2 : 1.0)
                    .foregroundColor(Color("purple1"))
                    
                }
                .font(.largeTitle)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack{
                            Text("CozyBlend Hoodie")
                            
                            
                            Spacer()
                            Button {
                                isFavorite.toggle()
                            } label: {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                            }
                            
                        }
                        .font(.title)
                        Text("Made with high-quality materials, our hoodie is designed to be ultra-soft and cozy, making it ideal for lounging around the house or heading out on a brisk day. The thick, yet breathable fabric will keep you warm without causing you to overheat, so you can wear it in any season.")
                            .font(.callout)
                        HStack{
                            HStack {
                                Button {
                                    withAnimation {
                                        decrementCartCount()
                                    }
                                } label: {
                                    Text("-")
                                }
                                
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(content: {
                                    Color.white.opacity(0.2)
                                })
                                .cornerRadius(100)
                                Text("\(numberOfItems)")
                                Button {
                                    withAnimation {
                                        incrementCartCount()
                                    }
                                } label: {
                                    Text("+")
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(content: {
                                    Color.white.opacity(0.2)
                                })
                                .cornerRadius(100)
                                Spacer()
                                HStack {
                                    Text("\(price)$")
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                    }
                                }
                                .padding(10)
                                .background {
                                    Color.white.opacity(0.2).cornerRadius(30)
                                }
                            }
                            
                        }
                        .font(.title)
                    }
                    Spacer()
                }
                .padding()
                .background {
                    Color("CustomColorPurple")
                        .cornerRadius(20)
                }
                
            }
            .foregroundColor(.white)
            .ignoresSafeArea()
            
        }
        
        
    }
    
    private func incrementCartCount() {
        numberOfItems += 1
        price += 99
    }
    
    private func decrementCartCount() {
        if numberOfItems > 0 {
            numberOfItems -= 1
            price -= 99
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

