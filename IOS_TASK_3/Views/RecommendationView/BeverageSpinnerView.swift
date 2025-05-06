import SwiftUI

struct BeverageSpinnerView: View {
    @State private var allowAlcohol = false
    @State private var selectedDrink: String?
    @State private var showResult = false

    var body: some View {
        ZStack {
            // Light blue gradient background
            LinearGradient(
                colors: [Color.blue.opacity(0.15), Color.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    // Title and subtitle
                    VStack(spacing: 6) {
                        Text("Discover Your Drink")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)

                        Text("Let the wheel suggest your next beverage")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Icon in circle background (like navigation card)
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.9))
                            .frame(width: 100, height: 100)

                        Image(systemName: "cup.and.saucer.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                    }
                    .shadow(radius: 4)

                    // Toggle to allow alcohol
                    Toggle("Include Alcoholic Drinks", isOn: $allowAlcohol)
                        .padding(.horizontal)

                    // Wheel with filtered categories
                    let drinks = allowAlcohol
                        ? CategoryData.beverageCategoriesAlcoholic + CategoryData.beverageCategoriesNonAlcoholic
                        : CategoryData.beverageCategoriesNonAlcoholic

                    RouletteWheelView(categories: drinks) { result in
                        selectedDrink = result
                        withAnimation {
                            showResult = true
                        }
                    }

                    // Instruction
                    Text("Tap the wheel to spin")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)

                    // Result view
                    if showResult, let drink = selectedDrink {
                        VStack(spacing: 12) {
                            Text("You got: \(drink)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)

                            HStack(spacing: 16) {
                                Button("Spin Again") {
                                    withAnimation {
                                        selectedDrink = nil
                                        showResult = false
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.15))
                                .foregroundColor(.primary)
                                .cornerRadius(10)

                                Button("Confirm") {
                                    print("Drink confirmed: \(drink)")
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
        .navigationTitle("Beverage Picker")
        .navigationBarTitleDisplayMode(.inline)
    }
}
