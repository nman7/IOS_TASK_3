//
//  ListTabView.swift
//  MapSearchPrototype
//
//  Created by Josh Tsai on 2025/5/5.
//

import SwiftUI
import CoreLocation
import MapKit

struct ListTabView: View {
    let places: [GooglePlace]
    @Binding var selectedPlace: GooglePlace?
    @Binding var region: MKCoordinateRegion
    let photoURL: (String) -> URL?
//    let fetchPlaceDetails: (GooglePlace) -> Void
    @Binding var selectedTab: String

    var body: some View {
        List(places.prefix(10)) { place in
            VStack(alignment: .leading, spacing: 8) {
                if let ref = place.photos?.first?.photo_reference,
                   let url = photoURL(ref) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 160)
                                .clipped()
                                .cornerRadius(8)
                        case .failure(_):
                            Color.gray.frame(height: 160).cornerRadius(8)
                        case .empty:
                            ProgressView().frame(height: 160)
                        @unknown default:
                            Color.gray.frame(height: 160).cornerRadius(8)
                        }
                    }
                }
                
//                let _ = {
//                    print("\(place.name): \(place)")
//                    return 0
//                }()

                Text(place.name)
                    .font(.headline)

                Text(place.formatted_address)
                    .font(.subheadline)

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
            .padding(.vertical, 8)
            .onTapGesture {
                selectedPlace = place
                region.center = CLLocationCoordinate2D(
                    latitude: place.geometry.location.lat,
                    longitude: place.geometry.location.lng
                )
//              fetchPlaceDetails(place)
                selectedTab = "Map"
            }
        }
    }
}

//#Preview {
//    ListTabView()
//}
