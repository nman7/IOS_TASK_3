//
//  FavouriteView.swift
//  Umm
//
//  Created by Kai-Hsuan Lin on 08/05/2025
//

import SwiftUI
import CoreLocation
import MapKit

struct FavouritesView: View {
    @EnvironmentObject var favouriteManager: FavouriteManager
    @StateObject private var locationManager = LocationManager()
    private let apiKey = "AIzaSyDL6ja_Bj23keyyWBuWwaTSn2nnUJwR800"
    
    private let photoURL: (String) -> URL? = { reference in
        URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=YOUR_API_KEY")
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if favouriteManager.favourites.isEmpty {
                    emptyStateView
                } else {
                    favouritesListView
                }
            }
            .navigationTitle("Favourites")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 15) {
            Image(systemName: "heart")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            VStack(spacing: 10) {
                Text("No Favourites list")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Tap the heart icon to add restaurants to your favourites!!")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
    }
    
    private var favouritesListView: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.gray.opacity(0.1), Color.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            List {
                Section(
                    header: Text("All your tasty treasures, saved just for you!")
                        .font(.caption)
                        .foregroundColor(.gray)
                ) {
                    ForEach(favouriteManager.favourites) { item in
                        NavigationLink {
                            MapDetailView(item: item)
                        } label: {
                            FavouriteRowView(item: item, photoURL: photoURL)
                        }
                    }
                    .onDelete { indexSet in
                        favouriteManager.favourites.remove(atOffsets: indexSet)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .toolbar {
                EditButton()
            }
        }
    }
}

struct FavouriteRowView: View {
    let item: FavouriteItem
    let photoURL: (String) -> URL?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Photo
            if let ref = item.photoReference, !ref.isEmpty,
               let url = photoURL(ref) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 65, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else if phase.error != nil {
                        placeholderImage
                    } else {
                        ProgressView()
                            .frame(width: 65, height: 80)
                    }
                }
            } else {
                placeholderImage
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(item.address)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Text(item.category)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 6)
    }
    
    private var placeholderImage: some View {
        ZStack {
            Color(.systemGray6)
                .frame(width: 65, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Image(systemName: "photo")
                .foregroundColor(.gray)
        }
    }
}
    
    
// MARK: - Subviews
private struct MapDetailView: View {
    @State private var region: MKCoordinateRegion
    let places: [GooglePlace]
    let item: FavouriteItem
    
    init(item: FavouriteItem) {
        self.item = item
        self.places = [GooglePlace]() // 初始化空陣列，或根據需要傳入實際值
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $region, interactionModes: [.all], annotationItems: places) { place in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: place.geometry.location.lat,
                        longitude: place.geometry.location.lng
                    )) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .background(Circle().fill(.white))
                    }
            }
            .mapStyle(.standard)
            
            // 縮放控制按鈕
            VStack(spacing: 12) {
                Button(action: zoomIn) {
                    Image(systemName: "plus")
                        .font(.body)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                }
                
                Button(action: zoomOut) {
                    Image(systemName: "minus")
                        .font(.body)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                }
            }
            .padding(.trailing, 12)
            .padding(.top, 30)
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func zoomIn() {
        withAnimation {
            region.span.latitudeDelta *= 0.8
            region.span.longitudeDelta *= 0.8
        }
    }
    
    func zoomOut() {
        withAnimation {
            region.span.latitudeDelta = min(region.span.latitudeDelta * 1.2, 180)
            region.span.longitudeDelta = min(region.span.longitudeDelta * 1.2, 180)
        }
    }
}
