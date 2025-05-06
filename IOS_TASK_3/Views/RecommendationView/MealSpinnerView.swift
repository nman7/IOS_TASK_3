import SwiftUI

struct MealSpinnerView: View {
    @State private var selectedMeal: String?
    @State private var showResult = false
    @State private var navigateToRecommendation = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Light Blue Background Gradient
                LinearGradient(
                    colors: [Color(red: 0.85, green: 0.93, blue: 1.0), Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        // Title & Subtitle
                        VStack(spacing: 6) {
                            Text("Discover Your Meal")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)

                            Text("Spin the wheel and let it decide for you")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        // Food Icon
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.9))
                                .frame(width: 100, height: 100)

                            Image(systemName: "fork.knife.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                        }
                        .shadow(radius: 4)

                        // Roulette Spinner
                        RouletteWheelView(categories: CategoryData.mealCategories) { result in
                            selectedMeal = result
                            withAnimation {
                                showResult = true
                            }
                        }

                        // Instruction
                        Text("Tap the wheel to spin")
                            .font(.caption)
                            .foregroundColor(.gray)

                        // Result View
                        if showResult, let meal = selectedMeal {
                            VStack(spacing: 14) {
                                Text("You got: \(meal)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)

                                Button("View Result") {
                                    navigateToRecommendation = true
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(10)
                            }
                            .padding(.top)
                            .animation(.easeInOut, value: showResult)
                        }

                        Spacer(minLength: 40)

                        // Navigation to RecommendationView
                        NavigationLink(
                            destination: RecommendationView(searchKeyword: selectedMeal ?? ""),
                            isActive: $navigateToRecommendation
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    .padding()
                }
            }
            .navigationTitle("Meal Picker")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
