import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.15), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    // App Title and Subtitle
                    VStack(spacing: 6) {
                        Text("Restaurant Roulette")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.primary)

                        Text("Let the wheel decide your cravings")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Central Illustration
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.blue.opacity(0.5))
                        .padding(.bottom, 12)

                    // Navigation Cards
                    VStack(spacing: 20) {
                        NavigationCardView(
                            icon: "fork.knife.circle.fill",
                            title: "Find a Restaurant",
                            subtitle: "Spin and discover your next dish",
                            color: .blue,
                            destination: RestaurantSpinnerView()
                        )

                        NavigationCardView(
                            icon: "cup.and.saucer.fill",
                            title: "Pick a Drink",
                            subtitle: "Choose something refreshing",
                            color: .green,
                            destination: BeverageSpinnerView()
                        )

                        NavigationCardView(
                            icon: "star.fill",
                            title: "Your Favourites",
                            subtitle: "Quick access to saved picks",
                            color: .orange,
                            destination: FavouriteView()
                        )
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct NavigationCardView<Destination: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 34))
                    .foregroundColor(.white)
                    .padding()
                    .background(color)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
