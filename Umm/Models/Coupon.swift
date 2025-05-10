//
//  Coupon.swift
//  Umm
//
//  Created by Waliul Islam on 9/5/2025.
//

import Foundation

/// A simple data model for coupons.
public struct Coupon: Identifiable, Codable {
  public let id: UUID
  public let title: String          // e.g. "10% off your next meal"
  public let discountPercent: Int   // e.g. 10
  public let minOrderValue: Double  // e.g. 25.0
  public let expiry: Date           // when it expires

  /// Formats expiry date like "Jun 5, 2025"
  public var expiryText: String {
    let f = DateFormatter()
    f.dateStyle = .medium
    return f.string(from: expiry)
  }
}
