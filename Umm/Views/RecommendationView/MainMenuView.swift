//
//  Created by nauman mansuri on 06/05/2025
//  Designed by Kai-Hsuan Lin on 09/05/2025
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            // Background Gradient
            ZStack {
                LinearGradient(
                    colors: [Color.gray.opacity(0.1), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Title & Image
                VStack {
                    VStack(spacing: 10) {
                        Text("UUUMM🤔MMUUU")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }

                    Spacer()
                    
                  VStack {
                        Text("👉👉👉👉👉🎯")
                          .font(.system(size: 40))
                        Text("🍔🍟🌮🍜🍦🍮")
                            .font(.system(size: 40))
                        Text("☕️🥤🧋🍺🍸🍹")
                          .font(.system(size: 40))
                    }
                    
                    Spacer()
                    
                    // Bottom Card Stack
                    VStack(spacing: 10) {
                        NavigationCardView(
                            icon: "🍜",
                            title: "What’s for Lunch ?",
                            subtitle: "Spin to pick a restaurant",
                            destination: RestaurantSpinnerView()
                        )

                        NavigationCardView(
                            icon: "🥤",
                            title: "Time for a Drink !",
                            subtitle: "Take a refreshing",
                            destination: BeverageSpinnerView()
                        )

                        NavigationCardView(
                            icon: "⭐️",
                            title: "Favourites ~",
                            subtitle: "Your top picks",
                            destination: FavouritesView()
                        )
                        
                        NavigationCardView(
                            icon: "🏷",
                            title: "Coupons *",
                            subtitle: "Every day discount",
                            destination: CouponsView()
                        )
                    }
                    .padding(.horizontal,30)
                    .padding(.bottom, 5) // Push it further down
                }
            }
        }
    }
}


struct NavigationCardView<Destination: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 10) {
                Text(icon)
                    .font(.system(size: 40))
                    .padding()
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "#999999"))
                }

                Spacer()
                
            }
            .padding()
            .frame(height: 90)
            .background(Color(.systemBackground))
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 0)
        }
    }
}

#Preview {
    MainMenuView()
}
