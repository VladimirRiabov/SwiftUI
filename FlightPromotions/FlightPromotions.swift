//
//  FlightPromotions.swift
//  Apps
//
//  Created by Владимир on 11.04.23.
//

import Foundation
import SwiftUI



struct FlightPromotionsView: View {
    @State var promos: [PromoFlight] = [
        .init(name: "SkyScanner", title: "Exclusive Weekend Getaway Deals", subTitle: "Save up to 40% on select flights", image: "flight"),
        .init(name: "CheapTickets", title: "Last Minute Flight Offers", subTitle: "Grab up to 30% off on last-minute bookings", image: "flight"),
        .init(name: "Airfarewatchdog", title: "Flash Sale: Limited Time Discounts", subTitle: "Up to 50% off on popular destinations", image: "flight"),
        .init(name: "Expedia", title: "Bundle & Save: Flight + Hotel Packages", subTitle: "Save up to 20% on your next vacation", image: "flight"),
        .init(name: "Kayak", title: "Early Bird Flight Deals", subTitle: "Book in advance and save up to 25% on flights", image: "flight"),
    ]
    @State private var showingDetail = false
    @State private var selectedPromotion: PromoFlight?
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.ignoresSafeArea()
                VStack {
                    Spacer()
                }
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(promos) { promotion in
                            CellView(promotion: promotion) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if let index = indexOf(promotion: promotion) {
                                        promos.remove(at: index)
                                    }
                                }
                            }
                            .onTapGesture {
                                selectedPromotion = promotion
                                showingDetail.toggle()
                            }
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.white)).opacity(0.8)
                            .ignoresSafeArea()
                    }
                    
                    .padding(10)
                }
                
            }.navigationTitle("Flight promotions")
                .sheet(item: $selectedPromotion) { promotion in
                    DetailView(promotion: promotion)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(300)])
                }
        }
    }
    
    
    func indexOf(promotion: PromoFlight) -> Int? {
        guard let index = promos.firstIndex(where: { $0.id == promotion.id }) else {
            return nil
        }
        return index
    }
}


struct CellView: View {
    var promotion: PromoFlight
    var icon: String = "xmark"
    var onDelete: () -> Void
    @State private var isSwiping = false
    @State private var swipeOffset: CGFloat = 0
    @State private var finishAnimation = false

    var body: some View {
        let cardWidth = UIScreen.main.bounds.width - 35
        let progress = min(max(swipeOffset / cardWidth, -1), 1)

        ZStack(alignment: .trailing) {
            canvasView()
                .padding(-20)

            HStack(spacing: 15) {
                Image(promotion.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)

                VStack(alignment: .leading, spacing: 6) {
                    Text(promotion.name)
                        .foregroundColor(.black)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Text(promotion.title)
                        .foregroundColor(.black.opacity(0.8))
                        .font(.caption)

                    Text(promotion.subTitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()
            }
            .padding(15)
            .frame(minHeight: 100)
            .background(RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.white)))
            .opacity(CGFloat(1) - abs(progress))
            .offset(x: swipeOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isSwiping {
                            isSwiping = abs(value.translation.width) > abs(value.translation.height)
                        }

                        if isSwiping {
                            swipeOffset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        let threshold = cardWidth * 0.6

                        if abs(swipeOffset) > threshold {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            finishAnimation = true

                            withAnimation(.easeInOut(duration: 0.3)) {
                                swipeOffset = -cardWidth
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                onDelete()
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                swipeOffset = 0
                            }
                        }

                        isSwiping = false
                    }
            )
        }
    }
    
    @ViewBuilder
    func canvasView() -> some View {
        let width = screenSize().width * 0.8
        let circleOffset = swipeOffset / width
        
        Canvas { context, canvasSize in
            // Apply filters to the canvas context
            context.addFilter(.alphaThreshold(min: 0.5, color: Color.blue))
            context.addFilter(.blur(radius: 6))
            
            // Draw the resolved view on the canvas
            context.drawLayer { layer in
                if let resolvedView = context.resolveSymbol(id: 1) {
                    layer.draw(resolvedView, at: CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2))
                }
            }
        } symbols: {
            dragView()
                .tag(1)
        }
        // Extract iconView into a separate function
        .overlay(alignment: .trailing) {
            iconView2(circleOffset: circleOffset)
        }
    }
    
    func iconView2(circleOffset: CGFloat) -> some View {
        let iconSize: CGFloat = 42
        let scaleFactor: CGFloat = 0.2
        let leadingOffset: CGFloat = 42
        let trailingOffset: CGFloat = 8
        
        return Image(systemName: icon)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: iconSize, height: iconSize)
            .offset(x: leadingOffset)
            .offset(x: (-circleOffset < 1.0 ? circleOffset : -1.0) * iconSize)
            .offset(x: swipeOffset * scaleFactor)
            .offset(x: trailingOffset)
            .offset(x: finishAnimation ? -200 : 0)
            .opacity(finishAnimation ? 0 : 1)
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 1, blendDuration: 1), value: finishAnimation)
    }
    
    @ViewBuilder
    func dragView() -> some View {
        let trailingOffset: CGFloat = 8
        let width = screenSize().width * 0.8
        let scale = finishAnimation ? -0.2 : (swipeOffset / width)
        let circleOffset = swipeOffset / width

        Image("Shape")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 100)
            .scaleEffect(x: -scale, anchor: .trailing)
            .scaleEffect(y: 1 + (-scale / 5), anchor: .center)
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6), value: finishAnimation)
            .overlay(alignment: .trailing, content: {
                iconView(circleOffset: circleOffset)
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .offset(x: trailingOffset)
    }

    // Extract iconView into a separate function and pass circleOffset as a parameter
    func iconView(circleOffset: CGFloat) -> some View {
        let iconSize: CGFloat = 42
        let scaleFactor: CGFloat = 0.2
        let leadingOffset: CGFloat = 42

        return Circle()
            .frame(width: iconSize, height: iconSize)
            .offset(x: leadingOffset)
            .scaleEffect(finishAnimation ? 0.001 : 1, anchor: .leading)
            .offset(x: (-circleOffset < 1.0 ? circleOffset : -1.0) * iconSize)
            .offset(x: swipeOffset * scaleFactor)
            .offset(x: finishAnimation ? -200 : 0)
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 1, blendDuration: 1), value: finishAnimation)
    }
}


extension View{
    func screenSize()->CGSize{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }

        return window.screen.bounds.size
    }
}

struct DetailView: View {
    var promotion: PromoFlight

    var body: some View {
        VStack {
            Image(promotion.image)
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
                .padding()
            Text(promotion.name)
                .font(.title)
            Text(promotion.title)
                .font(.subheadline)
                .padding(5)

            Text(promotion.subTitle)
                .font(.caption)
                .padding(5)

            Spacer()
        }
        .navigationTitle(promotion.name)
    }
}

struct PromoFlight: Identifiable{
    var id: String = UUID().uuidString
    var name: String
    var title: String
    var subTitle: String
    var image: String
}
