//
//  ListTabView.swift
//  MapSearchPrototype
//
//  Created by Josh Tsai on 2025/5/5.
//  Designed by Kai-Hsuan Lin on 2025/5/11.
//

import SwiftUI
import CoreLocation
import MapKit

struct ListTabView: View {
    let places: [GooglePlace]
    @Binding var selectedPlace: GooglePlace?
    @Binding var region: MKCoordinateRegion
    
    let photoURL: (String) -> URL?
    @Binding var selectedTab: String
    @EnvironmentObject var favouriteManager: FavouriteManager
    
    var body: some View {
        List(places.prefix(10)) { place in
            RestaurantCardView(
                place: place,
                isFavourite: favouriteManager.isFavourite(restaurantId: place.place_id),
                photoURL: photoURL,
                onSelect: {
                    selectedPlace = place
                    region.center = CLLocationCoordinate2D(
                        latitude: place.geometry.location.lat,
                        longitude: place.geometry.location.lng
                    )
                    selectedTab = "Map"
                },
                onToggleFavourite: {
                    toggleFavourite(place: place)
                }
            )
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    // Favourite function
    private func toggleFavourite(place: GooglePlace) {
        if favouriteManager.isFavourite(restaurantId: place.place_id) {
            favouriteManager.removeFavourite(byId: place.place_id)
        } else {
            favouriteManager.addFavourite(place)
        }
    }
}


// Card
struct RestaurantCardView: View {
    let place: GooglePlace
    let isFavourite: Bool
    let photoURL: (String) -> URL?
    let onSelect: () -> Void
    let onToggleFavourite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Photo Section
            photoSection
            
            // Info Section
            infoSection
            
            // Rating & Favorite
            ratingFavoriteSection
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .contentShape(Rectangle()) // 確保整個卡片區域都可點擊
        .onTapGesture(perform: onSelect)
    }
    
    private var photoSection: some View {
        Group {
            if let ref = place.photos?.first?.photo_reference,
               let url = photoURL(ref) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        placeholderImage
                    case .empty:
                        ProgressView()
                            .frame(height: 160)
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
        }
    }
    
    private var placeholderImage: some View {
        ZStack {
            Color(.systemGray6)
                .frame(height: 160)
                .cornerRadius(12)
            Image(systemName: "photo")
                .foregroundColor(.gray)
        }
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(place.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(place.formatted_address)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            if let openNow = place.opening_hours?.open_now {
                HStack(spacing: 4) {
                    Circle()
                        .fill(openNow ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(openNow ? "Open Now" : "Closed")
                        .font(.caption)
                        .foregroundColor(openNow ? .green : .red)
                }
            }
        }
    }
    
    // Rating
    private var ratingFavoriteSection: some View {
        HStack {
            if let rating = place.rating {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(rating, specifier: "%.1f")")
                        .font(.caption)
                        .bold()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            Spacer()
            
            // Favoutite button
            Button(action: onToggleFavourite) {
                Image(systemName: isFavourite ? "heart.fill" : "heart")
                    .foregroundColor(isFavourite ? .red : .gray)
                    .scaleEffect(isFavourite ? 1.2 : 1.0)
                    .frame(width: 30, height: 30) // 增加點擊區域
                    .contentShape(Rectangle()) // 確保整個按鈕區域可點擊
            }
            .buttonStyle(PlainButtonStyle()) // 移除按鈕的預設樣式
        }
    }
}

//#Preview {
//    ListTabView()
//}
