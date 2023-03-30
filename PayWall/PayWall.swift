//
//  PayWall.swift
//  Apps
//
//  Created by Владимир on 30.03.2023.
//

import SwiftUI
import StoreKit


@main
struct PayWall: App {
    @StateObject
    private var purchaseManager = PurchaseManager()
    
    var body: some Scene {
        WindowGroup {
            PayWallView()
                .statusBarHidden()
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}

struct PayWallView: View {
    @EnvironmentObject
    private var purchaseManager: PurchaseManager
    @State var showFirstScreen = true
    var body: some View {
        if showFirstScreen {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                SymbolView(color: .white.opacity(0.7))
                VStack {
                    Text("Unlock Premium Features")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Image(systemName: "lock.fill")
                        .font(.system(size: 100))
                        .padding()
                        .foregroundColor(.white)
                    Text("Upgrade to Premium to unlock all features and enjoy an ad-free experience.")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button(action: {
                        withAnimation {
                            showFirstScreen = false
                        }
                    }) {
                        Text("Upgrade to Premium")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                }
                //            .blur(radius: 10)
            }
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                SymbolView(color: .white.opacity(0.7))
                VStack(spacing: 20) {
                    if purchaseManager.hasUnlockedPro {
                        
                        VStack {
                            Image(systemName: "lock.open.fill")
                                .font(.system(size: 100))
                                .padding()
                                .foregroundColor(.white)
                            Text("Thank you")
                                .fontWeight(.heavy)
                                .font(.title)
                                .foregroundColor(.white)
                            Text("for purchasing pro!")
                                .fontWeight(.heavy)
                                .font(.title3)
                                .foregroundColor(.white)
                        }.transition(.opacity)
                        
                        
                        
                    } else {
                        VStack {
                            Text("Unlock Premium Features")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            ForEach(purchaseManager.products) { product in
                                Button {
                                    _ = Task<Void, Never> {
                                        do {
                                            try await purchaseManager.purchase(product)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            
                                            Text("\(product.displayName)")
                                                .font(.title3)
                                                .bold()
                                            
                                            Text("\(product.displayPrice)")
                                                .font(.callout)
                                                .bold()
                                            
                                            Text("\(product.description)")
                                                .font(.callout)
                                        }
                                        Spacer()
                                    }
                                      
                                }
                                
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(30)
                                .background(.purple)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .padding()
                            }
                            
                            Button {
                                _ = Task<Void, Never> {
                                    do {
                                        try await AppStore.sync()
                                    } catch {
                                        print(error)
                                    }
                                }
                            } label: {
                                Text("Restore Purchases")
                                    .foregroundColor(.purple)
                                    .font(.headline)
                                    .padding(15)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .padding(30)
                            }
                        }.transition(.opacity)
                    }
                }.task {
                    _ = Task<Void, Never> {
                        do {
                            try await purchaseManager.loadProducts()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        
    }
}

@MainActor
class PurchaseManager: ObservableObject {
    
    private let productIds = ["monthly", "yearly"]
    
    @Published
    private(set) var products: [Product] = []
    @Published
    private(set) var purchasedProductIDs = Set<String>()
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    init() {
        self.updates = observeTransactionUpdates()
    }
    
    deinit {
        self.updates?.cancel()
    }
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            // Successful purchase
            await transaction.finish()
            await self.updatePurchasedProducts()
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}

struct Dollar {
    let id = UUID()
    let symbol = "$"
}


struct SymbolView: View {
    @State var animate = false
    let symbols = [ Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(),Dollar(), Dollar(), ]
    let color: Color
    var body: some View {
        ZStack {
            ForEach(symbols, id: \.id) { symbol in
                Text(symbol.symbol)
                    .font(.system(size: 45))
                    .foregroundColor(color)
                    .opacity(Double.random(in: 0.1...0.7))
                    .scaleEffect(CGFloat.random(in: 0.05...1))
                    .rotationEffect(.degrees(Double.random(in: 0...360)), anchor: .center)
                    .position(CGPoint(x: CGFloat.random(in: 0..<UIScreen.main.bounds.width), y: CGFloat.random(in: 0..<UIScreen.main.bounds.height)))
                    .animation(.linear(duration: 80).repeatForever(autoreverses: true), value: animate)
            }
            
            ForEach(symbols, id: \.id) { symbol in
                Text(symbol.symbol)
                    .font(.system(size: 30))
                    .foregroundColor(color)
                    .opacity(Double.random(in: 0.05...0.4))
                    .scaleEffect(CGFloat.random(in: 0.1...1))
                    .rotationEffect(.degrees(Double.random(in: 0...360)), anchor: .center)
                    .position(CGPoint(x: CGFloat.random(in: 0..<UIScreen.main.bounds.width + 100), y: CGFloat.random(in: 0..<UIScreen.main.bounds.height + 100)))
                    .animation(.linear(duration: 100).repeatForever(autoreverses: true), value: animate)
            }
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animate = true
            }
            
        }
    }
}
