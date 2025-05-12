//
//  Created by nauman mansuri on 06/05/2025
//  Designed by Kai-Hsuan Lin on 09/05/2025
//

import SwiftUI

struct BeverageSpinnerView: View {
    @State private var selectedDrink: String?
    @State private var showResult = false
    @State private var navigateToRecommendation = false
    @State private var allowAlcohol = false
    
    @State private var isAlcoholic = false
    @State private var key = UUID() // Recreate Roulette

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.gray.opacity(0.1), Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 10) {
                    // Title and subtitle
                    VStack(spacing: 6) {
                        Text("Time for a Drink")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Text("Feeling thirsty? Let’s sip on something yummy!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // Drink Icon
                    HStack {
                        Text("🥤")
                            .font(.system(size: 40))
                            .frame(width: 237.5, alignment: .trailing)
                        // Toggle
                        Toggle("Alcoholic Switch", isOn: $isAlcoholic)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .onChange(of: isAlcoholic) { _ in
                                key = UUID() // 強制重新創建視圖
                            }
                        Spacer(minLength: 25)
                    }

                    // Roulette Spinner
                        RouletteWheelView(
                            allCategories: isAlcoholic ?
                                CategoryTypeData.BeverageCategoriesAlcoholic :
                                CategoryTypeData.BeverageCategoriesNonAlcoholic,
                            onResult: { result in
                                selectedDrink = result
                                withAnimation {
                                    showResult = true
                                }
                            }
                        )
                        .id(key) // / 強制重新創建視圖

                    // Result View
                    if showResult, let drink = selectedDrink {
                        VStack(spacing: 10) {
                            Text("You got")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("\(drink)")
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
                        destination: RecommendationView(searchKeyword: selectedDrink ?? ""),
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
//    BeverageSpinnerView()
//}
