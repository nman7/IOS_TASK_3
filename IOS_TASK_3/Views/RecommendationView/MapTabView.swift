//
//  MapTabView.swift
//  MapSearchPrototype
//
//  Created by Josh Tsai on 2025/5/5.
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
//    let fetchPlaceDetails: (GooglePlace) -> Void
    let selectedPhoneNumber: String?

    var body: some View {
        // Combine places.filter and selectedPlace into sortedPlaces
//        let sortedPlaces = places.filter { $0.name != selectedPlace?.name } + (selectedPlace.map { [$0] } ?? [])
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $region, interactionModes: [.all], annotationItems: places) { place in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: place.geometry.location.lat,
                        longitude: place.geometry.location.lng
                    )
                ) {
                    mapMarker(for: place, isSelected: selectedPlace?.name == place.name)
                }
            }
            .frame(height: 300)

            VStack {
                Button(action: {
                    region.span.latitudeDelta *= 0.8
                    region.span.longitudeDelta *= 0.8
                }) {
                    Image(systemName: "plus.magnifyingglass")
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }

                Button(action: {
                    region.span.latitudeDelta *= 1.2
                    region.span.longitudeDelta *= 1.2
                }) {
                    Image(systemName: "minus.magnifyingglass")
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
            }
            .padding()
        }

        Spacer()

        if let place = selectedPlace {
            VStack(alignment: .leading, spacing: 4) {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        selectedPlace = nil
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                }

                let allPhotos = detailedPhotos.isEmpty ? (place.photos ?? []) : detailedPhotos
                if !allPhotos.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(allPhotos.indices, id: \.self) { index in
                                if let url = photoURL(allPhotos[index].photo_reference) {
                                    let _ = {
                                        print("photo URL: \(url)")
                                        return 0
                                    }()
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 160)
                                                .clipped()
                                                .cornerRadius(8)
                                        case .failure(_):
                                            Color.gray
                                                .frame(width: 200, height: 160)
                                                .cornerRadius(8)
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 200, height: 160)
                                        @unknown default:
                                            Color.gray
                                                .frame(width: 200, height: 160)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Text(place.name)
                    .font(.headline)

                Text(place.formatted_address)
                    .font(.subheadline)
                
                if let phone = selectedPhoneNumber {
                    Text("Phone: \(phone)")
                        .font(.caption)
                }
                
                if let openNow = place.opening_hours?.open_now {
                    Text(openNow ? "Open now" : "Closed now")
                        .font(.caption)
                        .foregroundColor(openNow ? .green : .red)
                }

                if !place.types.isEmpty {
                    Text("Type: \(place.types.joined(separator: ", "))")
                        .font(.caption)
                }

                if let rating = place.rating {
                    Text("Rating: \(rating, specifier: "%.1f") ⭐️")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
        }
    }

    @ViewBuilder
    private func mapMarker(for place: GooglePlace, isSelected: Bool) -> some View {
        ZStack {
            if let ref = place.photos?.first?.photo_reference,
               let url = photoURL(ref) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(isSelected ? Color.yellow : Color.white, lineWidth: isSelected ? 3 : 2))
                            .shadow(radius: 3)
                            .onTapGesture {
                                selectedPlace = place
                                region.center = CLLocationCoordinate2D(
                                    latitude: place.geometry.location.lat,
                                    longitude: place.geometry.location.lng
                                )
                                region.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//                                fetchPlaceDetails(place)
                            }
                    case .failure(_):
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 60, height: 60)
                    case .empty:
                        ProgressView().frame(width: 60, height: 60)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                        selectedPlace = place
                        region.center = CLLocationCoordinate2D(
                            latitude: place.geometry.location.lat,
                            longitude: place.geometry.location.lng
                        )
//                        fetchPlaceDetails(place)
                    }
            }
        }
    }
}


//#Preview {
//    MapTabView()
//}
