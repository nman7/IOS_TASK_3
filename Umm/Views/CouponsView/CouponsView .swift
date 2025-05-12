//
//  CouponsView.swift
//  Umm
//
//  Created by Kai-Hsuan Lin on 11/05/2025
//

import SwiftUI

struct CouponsView : View {
    
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
                    // Title & Subtitle
                    VStack(spacing: 6) {
                        Text("Coupons")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Let's see what surprises discounts there are today")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
            }
        }
    }
}
