//
//  Coupon.swift
//  Umm
//
//  Created by Waliul Islam on 9/5/2025.
//  Changed by Kai-Hsuan Lin on 12/05/2025
//

import Foundation

public struct Coupon: Identifiable, Codable {
    public let id: UUID
    public let title: String          // 10% off your next meal
    public let discountPercent: Int   // 10
    public let minOrderValue: Double  // 25.0
    public let expiry: Date           // When it expires
    public let code: String           // Coupon code for display
    
    public init(id: UUID = UUID(), title: String, discountPercent: Int, minOrderValue: Double, expiry: Date, code: String = "") {
        self.id = id
        self.title = title
        self.discountPercent = discountPercent
        self.minOrderValue = minOrderValue
        self.expiry = expiry
        self.code = code.isEmpty ? String(UUID().uuidString.prefix(8)).uppercased() : code
    }
    
    // Formats expiry date like "10 MAY 2025"
    public var expiryText: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: expiry)
    }
    
    // Short expiry for coupon display
    public var shortExpiry: String {
        let f = DateFormatter()
        f.dateFormat = "DD MM YY"
        return "Valid until " + f.string(from: expiry)
    }
    
    // Formatted discount text
    public var discountText: String {
        return "\(discountPercent)% OFF"
    }
    
    // Formatted minimum order text
    public var minOrderText: String {
        return minOrderValue > 0 ? "Min. order: $\(String(format: "%.2f", minOrderValue))" : "No minimum order"
    }
}
