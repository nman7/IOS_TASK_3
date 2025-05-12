//
//  MapTabView.swift
//  MapSearchPrototype
//
//  Created by Josh Tsai on 2025/5/5.
//  Designed by Kai-Hsuan Lin on 2025/5/11.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapTabView: View {
    @Binding var region: MKCoordinateRegion
    let places: [GooglePlace]
    
    @Binding var selectedPlace: GooglePlace?
    let detailedPhotos: [GooglePlace.Photo]
    let photoURL: (String) -> URL?
    let selectedPhoneNumber: String?
    
    @EnvironmentObject var favouriteManager: FavouriteManager
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                // Map Section
                ZStack(alignment: .topTrailing) {
                    Map(coordinateRegion: $region, interactionModes: [.all], annotationItems: places) { place in
                        MapAnnotation(
                            coordinate: CLLocationCoordinate2D(
                                latitude: place.geometry.location.lat,
                                longitude: place.geometry.location.lng
                            )
                        ) {
                            MapMarkerView(
                                place: place,
                                isSelected: selectedPlace?.place_id == place.place_id,
                                photoURL: photoURL,
                                onSelect: {
                                    selectPlace(place)
                                }
                            )
                        }
                    }
                    .frame(height: geometry.size.height * 0.45) // Map Size
                    .edgesIgnoringSafeArea(.horizontal)
                    
                    // Zoom Controls
                    VStack(spacing: 10) {
                        zoomButton(icon: "plus.magnifyingglass", action: zoomIn)
                        zoomButton(icon: "minus.magnifyingglass", action: zoomOut)
                    }
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                }
                
                // Place Detail Section
                if let place = selectedPlace {
                    PlaceDetailCard(
                        place: place,
                        detailedPhotos: detailedPhotos,
                        selectedPhoneNumber: selectedPhoneNumber,
                        photoURL: photoURL,
                        isFavourite: favouriteManager.isFavourite(restaurantId: place.place_id),
                        onToggleFavourite: {
                            toggleFavourite(place: place)
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
            }
        }
    }
    
    private func selectPlace(_ place: GooglePlace) {
        withAnimation {
            selectedPlace = place
            region.center = place.location
            region.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        }
    }
    
    // Favourite function
    private func toggleFavourite(place: GooglePlace) {
        withAnimation(.spring()) {
            if favouriteManager.isFavourite(restaurantId: place.place_id) {
                favouriteManager.removeFavourite(byId: place.place_id)
            } else {
                favouriteManager.addFavourite(place)
            }
        }
    }
    
    private func zoomIn() {
        withAnimation {
            region.span.latitudeDelta *= 0.8
            region.span.longitudeDelta *= 0.8
        }
    }
    
    private func zoomOut() {
        withAnimation {
            region.span.latitudeDelta = min(region.span.latitudeDelta * 1.2, 180)
            region.span.longitudeDelta = min(region.span.longitudeDelta * 1.2, 180)
        }
    }
    
    private func zoomButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.body)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.6))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
        }
    }
}

// MARK: - Subviews

struct MapMarkerView: View {
    let place: GooglePlace
    let isSelected: Bool
    let photoURL: (String) -> URL?
    let onSelect: () -> Void
    
    var body: some View {
        ZStack {
            if let ref = place.photos?.first?.photo_reference,
               let url = photoURL(ref) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: isSelected ? 50 : 40, height: isSelected ? 50 : 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(isSelected ? Color.orange : Color.white, lineWidth: isSelected ? 3 : 2))
                            .shadow(radius: 3)
                    default:
                        placeholderMarker
                    }
                }
            } else {
                placeholderMarker
            }
        }
        .onTapGesture(perform: onSelect)
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.spring(), value: isSelected)
    }
    
    private var placeholderMarker: some View {
        Circle()
            .fill(isSelected ? Color.orange : Color.blue)
            .frame(width: isSelected ? 50 : 40, height: isSelected ? 50 : 40)
            .overlay(
                Image(systemName: "mappin")
                    .foregroundColor(.white)
                    .font(.system(size: isSelected ? 16 : 14))
            )
    }
}


// Card
struct PlaceDetailCard: View {
    let place: GooglePlace
    let detailedPhotos: [GooglePlace.Photo]
    let selectedPhoneNumber: String?
    let photoURL: (String) -> URL?
    let isFavourite: Bool
    let onToggleFavourite: () -> Void
    
    private var allPhotos: [GooglePlace.Photo] {
        detailedPhotos.isEmpty ? (place.photos ?? []) : detailedPhotos
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !allPhotos.isEmpty {
                TabView {
                    ForEach(allPhotos.indices, id: \.self) { index in
                        if let url = photoURL(allPhotos[index].photo_reference) {
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
                        }
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 160)
                .cornerRadius(10)
            } else {
                placeholderImage
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(place.formatted_address)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                if let phone = selectedPhoneNumber {
                    HStack(spacing: 4) {
                        Text(phone)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                if let openNow = place.opening_hours?.open_now {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(openNow ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(openNow ? "Open Now" : "Closed")
                            .font(.caption)
                            .foregroundColor(openNow ? .green : .red)
                        Spacer(minLength: 3)
                    }
                }
                
                // Rating
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
                            .frame(width: 30, height: 30)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
    
    private var placeholderImage: some View {
        ZStack {
            Color(.systemGray6)
                .frame(height: 160)
                .cornerRadius(10)
            Image(systemName: "photo")
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Extensions

extension GooglePlace {
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: geometry.location.lat,
            longitude: geometry.location.lng
        )
    }
}
    
//#Preview {
//    MapTabView()
//}
