//
//  CouponsView.swift
//  Umm
//
//  Created by Waliul Islam on 11/5/2025.
//  Changed by Kai-Hsuan Lin on 12/05/2025
//  Designed by Kai-Hsuan Lin on 12/05/2025
//

import SwiftUI

struct Coupons: Identifiable {
    let id: UUID
    let title: String
    let discountPercent: Int
    let minOrderValue: Double
    let expiry: Date
    let code: String
}

struct CouponsView: View {
    let coupons: [Coupon]

    var body: some View {
        NavigationStack {
            Group {
                if coupons.isEmpty {
                    emptyStateView
                } else {
                    couponListView
                }
            }
            .navigationTitle("Coupons*")
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Image(systemName: "Tag")
                .font(.system(size: 50))
                .foregroundColor(.gray)

            VStack(spacing: 10) {
                Text("No coupons list")
                    .font(.headline)
                    .foregroundColor(.gray)

                Text("Visit the restaurant to add coupons to your list!!")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
    }
    
    
    private var couponListView: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today’s Promo Codes!")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(coupons.prefix(5)) { coupon in
                                Text(coupon.code)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.1))
                                    .foregroundColor(.orange)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.orange, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    ForEach(coupons) { coupon in
                        CouponCard(coupon: coupon)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }


// CouponCard
struct CouponCard: View {
    let coupon: Coupon

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(coupon.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("CODE: \(coupon.code)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            HStack(spacing: 20) {
                Label("\(coupon.discountPercent)% OFF", systemImage: "tag.fill")
                    .font(.headline)
                    .foregroundColor(.green)
                Spacer()
                Label("min $\(String(format: "%.2f", coupon.minOrderValue))", systemImage: "cart.fill")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Text("Expires on \(coupon.expiry.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 0)
        )
    }
}
