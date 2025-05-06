import SwiftUI

struct MealSpinnerView: View {
    @State private var selectedMeal: String?
    @State private var showResult = false

    var body: some View {
        ZStack {
            // Light Blue Background Gradient (matches main screen)
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

                    // Matching Food Icon from main page
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

                            HStack(spacing: 16) {
                                Button("Spin Again") {
                                    withAnimation {
                                        selectedMeal = nil
                                        showResult = false
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.15))
                                .foregroundColor(.primary)
                                .cornerRadius(10)

                                Button("Confirm") {
                                    print("Meal confirmed: \(meal)")
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top)
                        .animation(.easeInOut, value: showResult)
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
        .navigationTitle("Meal Picker")
        .navigationBarTitleDisplayMode(.inline)
    }
}
