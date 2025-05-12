//
//  Created by nauman mansuri on 06/05/2025
//  Designed by Kai-Hsuan Lin on 09/05/2025
//

import SwiftUI

struct RestaurantSpinnerView: View {
    @State private var selectedMeal: String?
    @State private var showResult = false
    @State private var navigateToRecommendation = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.gray.opacity(0.2), Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Title & Subtitle
                    VStack(spacing: 6) {
                        Text("What’s for Lunch?")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Text("Give it a spin and let fate choose your feast!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // Food Icon
                    ZStack {
                        Text("🍜")
                            .font(.system(size: 40))
                    }

                    // Roulette Spinner
                    RouletteWheelView(allCategories: CategoryTypeData.RestaurantCategories) { result in
                        selectedMeal = result
                        withAnimation {
                            showResult = true
                        }
                    }

                    // Result View
                    if showResult, let meal = selectedMeal {
                        VStack(spacing: 10) {
                            Text("You got")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("\(meal)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "#ff6600"))

                            Button("View Result") {
                                navigateToRecommendation = true
                            }
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .background(Color(hex: "#ff6600"))
                            .cornerRadius(25)
                        }
                        .padding(.top)
                        .animation(.easeInOut, value: showResult)
                    }

                    // Instruction
                    Text("Tap the wheel to spin")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Navigation to RecommendationView
                    NavigationLink(
                        destination: RecommendationView(searchKeyword: selectedMeal ?? ""),
                        isActive: $navigateToRecommendation
                    ) {
                        EmptyView()
                    }
                    .padding(.horizontal)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

//#Preview {
//    RestaurantSpinnerView()
//}
