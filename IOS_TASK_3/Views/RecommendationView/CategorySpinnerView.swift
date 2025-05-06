import SwiftUI

struct CategorySpinnerView: View {
    @State private var isVegetarianOnly = false
    @State private var allowAlcohol = false

    @State private var mealChoice: String?
    @State private var drinkChoice: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                Text("Find Something to Eat or Drink")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 8)

                VStack(alignment: .leading, spacing: 12) {
                    Toggle("Vegetarian Options Only", isOn: $isVegetarianOnly)
                    Toggle("Include Alcoholic Beverages", isOn: $allowAlcohol)
                }
                .padding(.horizontal)

                Divider().padding(.vertical)

                VStack(spacing: 20) {
                    Text("Meal Selector")
                        .font(.headline)

                    RouletteWheelView(categories: CategoryData.mealCategories) { result in
                        mealChoice = result
                    }

                    if let meal = mealChoice {
                        VStack(spacing: 10) {
                            Text("You selected: \(meal)")
                                .foregroundColor(.primary)
                                .bold()

                            HStack(spacing: 16) {
                                Button("Spin Again") {
                                    mealChoice = nil
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(10)

                                Button("Confirm Meal") {
                                    print("Meal confirmed: \(meal)")
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 12)
                    }
                }

                Divider().padding(.vertical)

                VStack(spacing: 20) {
                    Text("Beverage Selector")
                        .font(.headline)

                    let beverageList = allowAlcohol
                        ? CategoryData.beverageCategoriesAlcoholic + CategoryData.beverageCategoriesNonAlcoholic
                        : CategoryData.beverageCategoriesNonAlcoholic

                    RouletteWheelView(categories: beverageList) { result in
                        drinkChoice = result
                    }

                    if let drink = drinkChoice {
                        VStack(spacing: 10) {
                            Text("You selected: \(drink)")
                                .foregroundColor(.primary)
                                .bold()

                            HStack(spacing: 16) {
                                Button("Spin Again") {
                                    drinkChoice = nil
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(10)

                                Button("Confirm Drink") {
                                    print("Drink confirmed: \(drink)")
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 12)
                    }
                }

                Spacer(minLength: 40)
            }
            .padding()
        }
    }
}
