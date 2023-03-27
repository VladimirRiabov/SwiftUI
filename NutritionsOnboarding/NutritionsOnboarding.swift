//
//  NutritionsOnboarding.swift
//  Apps
//
//  Created by Владимир on 27.03.2023.
//

import SwiftUI

struct OnboardingView: View {
  @AppStorage("isOnboarding") var isOnboarding: Bool?
  var nutritions: [NutritionItem] = nutritionsData
  var body: some View {
    VStack {
      TabView {
        ForEach(nutritions[0...5]) { item in
          NutritionCard(nutrition: item)
        }
      }
      .tabViewStyle(PageTabViewStyle())
      .padding(.vertical, 20)

        Button(action: {
            isOnboarding = false
        }, label: {
            Text("Get Started")
                .font(.headline)
                .foregroundColor(.black).opacity(0.8)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                        .opacity(0.5)
                )
                .padding(20)
        })
        .padding(.top, 20)
    }
  }
}


struct NutritionItem: Identifiable {
  var id = UUID()
  var title: String
  var headline: String
  var image: String
  var gradientColors: [Color]
  var description: String

}

struct NutritionCard: View {
  var nutrition: NutritionItem
  @State private var isAnimating: Bool = false
  var body: some View {
    ZStack {
      VStack(spacing: 20) {
        Image(nutrition.image)
          .resizable()
          .scaledToFit()
          .scaleEffect(isAnimating ? 1.2 : 1.0)
          .cornerRadius(20)
          .padding()

        Text(nutrition.title)
          .foregroundColor(Color.white)
          .font(.largeTitle)
          .fontWeight(.black)

        Text(nutrition.headline)
          .foregroundColor(Color.white)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 16)

        
      }
    }
    .onAppear {
      withAnimation(.easeOut(duration: 6)) {
        isAnimating = true
      }
    }
    
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    .background(LinearGradient(gradient: Gradient(colors: nutrition.gradientColors), startPoint: .top, endPoint: .bottom))
    .cornerRadius(20)
    .padding(.horizontal, 20)
  }
}


let nutritionsData = [NutritionItem(
    title: "Green Smoothie",
    headline: "Get Your Daily Dose of Greens",
    image: "green-smoothie-image",
    gradientColors: [.green, .blue],
    description: "Green smoothies are a great way to get a healthy dose of greens into your diet. They're easy to make and can be customized to your taste preferences. Simply blend together your favorite leafy greens, fruits, and liquid of choice (such as water, coconut water, or almond milk) for a refreshing and nutritious drink. Green smoothies are packed with vitamins, minerals, and fiber, making them a great addition to any meal or snack."
  ),
                  NutritionItem(
                    title: "Ancient Grains",
                    headline: "Discover the Nutritional Benefits of Ancient Grains",
                    image: "ancient-grains-image",
                    gradientColors: [.yellow, .orange],
                    description: "Ancient grains such as quinoa, farro, and amaranth are gaining popularity due to their many nutritional benefits. These grains are rich in protein, fiber, and important vitamins and minerals. They're also gluten-free and can be used in a variety of recipes, from salads to soups to breakfast bowls. By incorporating ancient grains into your diet, you can improve your digestive health, boost your energy levels, and support overall wellness."
                  ),
                  NutritionItem(
                    title: "Immunity Boost",
                    headline: "Nourish Your Immune System with These Foods",
                    image: "immunity-boost-image",
                    gradientColors: [.purple, .pink],
                    description: "Your immune system plays a crucial role in keeping you healthy, and certain foods can help support its function. Foods high in vitamin C, such as citrus fruits and leafy greens, can help boost your immune system. Fermented foods, such as kimchi and kefir, contain beneficial probiotics that can improve gut health and support immunity. Additionally, spices like turmeric and ginger have anti-inflammatory properties that can help reduce inflammation in the body. By incorporating these foods into your diet, you can give your immune system the support it needs to function at its best."
                  ),
                  NutritionItem(
                    title: "Brain Food",
                    headline: "Fuel Your Brain with These Nutrient-Rich Foods",
                    image: "brain-food-image",
                    gradientColors: [.blue, .purple],
                    description: "The brain requires a steady supply of nutrients to function at its best, and certain foods can provide these nutrients. Foods high in omega-3 fatty acids, such as fatty fish and flaxseeds, can help support brain health and improve cognitive function. Blueberries, walnuts, and dark chocolate are also great options for boosting brain function due to their high antioxidant content. By incorporating these brain-boosting foods into your diet, you can improve your memory, concentration, and overall brain health."
                  ),
                  NutritionItem(
                    title: "Post-Workout Fuel",
                    headline: "Replenish Your Body with the Right Nutrition After a Workout",
                    image: "post-workout-fuel-image",
                    gradientColors: [.orange, .red],
                    description: "After a workout, it's important to provide your body with the right nutrition to aid in recovery and replenish energy stores. Foods high in protein, such as chicken, eggs, and Greek yogurt, can help repair and build muscle tissue. Carbohydrates, such as sweet potatoes and brown rice, can help replenish glycogen stores and provide energy. Additionally, hydration is crucial after a workout, so be sure to drink plenty of water or an electrolyte-rich beverage. By fueling your body with the right nutrients after a workout, you can improve your recovery time, reduce muscle soreness, and improve overall performance."),
                  NutritionItem(
                  title: "Gut Health",
                  headline: "Support Your Gut Microbiome for Improved Health",
                  image: "gut-health-image",
                  gradientColors: [.green, .yellow],
                  description: "The gut microbiome plays a critical role in overall health, and certain foods can help support its function. Fermented foods such as sauerkraut, kefir, and miso contain beneficial probiotics that can improve gut health and support digestion. Foods high in fiber, such as fruits, vegetables, and whole grains, can also help support a healthy gut microbiome. Additionally, bone broth contains important amino acids that can help heal the gut lining and reduce inflammation. By incorporating these gut-healthy foods into your diet, you can improve your digestion, boost your immune system, and support overall wellness."
                  )
 
]
