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
                            destination: CouponsView(coupons: [
                                Coupon(id: UUID(), title: "Welcome Offer 15%", discountPercent: 15, minOrderValue: 20.0, expiry: Date().addingTimeInterval(365 * 86400), code: "WELCOME15"),
                                Coupon(id: UUID(), title: "10% Off Lunch", discountPercent: 10, minOrderValue: 15.0, expiry: Date().addingTimeInterval(7 * 86400), code: "LUNCH10"),
                                Coupon(id: UUID(), title: "Buy 1 Get 1 Free", discountPercent: 50, minOrderValue: 25.0, expiry: Date().addingTimeInterval(7 * 86400), code: "BUY1GET1"),
                                Coupon(id: UUID(), title: "Summer Sale 10%", discountPercent: 10, minOrderValue: 20.0, expiry: Date().addingTimeInterval(30 * 86400), code: "SUMMER10"),
                                Coupon(id: UUID(), title: "Birthday Gift 30%", discountPercent: 30, minOrderValue: 25.0, expiry: Date().addingTimeInterval(30 * 86400), code: "BIRTHDAY30")
                            ])
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
