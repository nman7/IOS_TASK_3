//
//  RecommendationView.swift
//  IOS_TASK_3
//
//  Created by Josh Tsai on 2025/5/5.
//

import SwiftUI
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var region: MKCoordinateRegion?
    @Published var hasUpdatedRegion = false
    @EnvironmentObject var favouriteManager: FavouriteManager

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                self.hasUpdatedRegion = true
            }
            manager.stopUpdatingLocation()
        }
    }
}


struct GooglePlace: Identifiable, Codable, Equatable {
    let id = UUID()
    let place_id: String
    let name: String
    let formatted_address: String
    let types: [String]
    let geometry: Geometry
    let opening_hours: OpeningHours?
    let photos: [Photo]?
    let rating: Double?

    struct Geometry: Codable, Equatable {
        let location: Location
        struct Location: Codable, Equatable {
            let lat: Double
            let lng: Double
        }
    }

    struct OpeningHours: Codable, Equatable {
        let open_now: Bool?
    }

    struct Photo: Codable, Equatable {
        let photo_reference: String
        }
    }

    struct GooglePlacesResponse: Codable {
        let results: [GooglePlace]
    }

    struct CachedGooglePlacesResponse: Codable {
        let results: [GooglePlace]
    }

    struct GooglePlaceDetailsResponse: Codable {
        let result: GooglePlaceDetails
    }

    struct GooglePlaceDetails: Codable {
        let photos: [GooglePlace.Photo]?
        let formatted_phone_number: String?
        let international_phone_number: String?
    }

    struct RecommendationView: View {
        let searchKeyword: String
        @State private var searchText = ""
        @State private var places: [GooglePlace] = []
        // Tab state for List/Map toggle
        @State private var selectedTab = "List"
        private let tabs = ["List", "Map"]
        @State private var selectedPlace: GooglePlace? = nil
        @State private var detailedPhotos: [GooglePlace.Photo] = []
        @State private var selectedPhoneNumber: String? = nil
        @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        @StateObject private var locationManager = LocationManager()
        private let apiKey = "AIzaSyDL6ja_Bj23keyyWBuWwaTSn2nnUJwR800"
        
        @StateObject private var favouriteManager = FavouriteManager()

        var body: some View {
            NavigationStack {
                VStack {
                    Picker("View Mode", selection: $selectedTab) {
                        ForEach(tabs, id: \.self) { tab in
                            Text(tab).tag(tab)
                        }
                    }
                    .navigationTitle(searchKeyword)
                    .environmentObject(favouriteManager)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    if selectedTab == "Map" {
                        MapTabView(
                            region: $region,
                            places: places,
                            selectedPlace: $selectedPlace,
                            detailedPhotos: detailedPhotos,
                            photoURL: photoURL,
                            //  fetchPlaceDetails: fetchPlaceDetails,
                            selectedPhoneNumber: selectedPhoneNumber,
                            userLocation: locationManager.region?.center
                        )
                    } else {
                        ListTabView(
                            places: places,
                            selectedPlace: $selectedPlace,
                            region: $region,
                            photoURL: photoURL,
                            //  fetchPlaceDetails: fetchPlaceDetails,
                            selectedTab: $selectedTab
                        )
                    }
                }
                .navigationTitle(searchKeyword)
                .onAppear {
                    let status = CLLocationManager().authorizationStatus
                    if status == .authorizedWhenInUse || status == .authorizedAlways {
                        if let newRegion = locationManager.region {
                            self.region = newRegion
                            searchPlaces()
                        }
                    }

                }
                .onChange(of: selectedTab) { (oldTab, newTab) in
                    if (newTab == "Map") {
                        if (selectedPlace == nil) {
                            selectedPlace = places.first
                        }
                    } else {
                        selectedPlace = nil
                    }
                }
                .onChange(of: selectedPlace) { (oldPlace, newPlace) in
                    if let place = newPlace {
                        region.center = CLLocationCoordinate2D(
                            latitude: place.geometry.location.lat,
                            longitude: place.geometry.location.lng
                        )
                        fetchPlaceDetails(for: place)
                    }
                }
                .onChange(of: locationManager.hasUpdatedRegion) { (before, updated) in
                    let status = CLLocationManager().authorizationStatus
                    if updated && (status == .authorizedWhenInUse || status == .authorizedAlways) {
                        if let newRegion = locationManager.region {
                            self.region = newRegion
                            self.searchText = self.searchKeyword
                            searchPlaces()
                        }
                    } else {
                        searchPlaces()
                    }
                }
            }
        }

    func searchPlaces() {
        let query = searchText.isEmpty ? searchKeyword : searchText
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let location = "-33.883888, 151.199231" // Default: UTS, Sydney
        let radius = 5000
        let urlStr = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(query)&location=\(location)&radius=\(radius)&key=\(apiKey)"
        let cacheKey = "placesCache_\(urlStr)"
        if let cachedData = UserDefaults.standard.data(forKey: cacheKey),
           let cachedResult = try? JSONDecoder().decode(CachedGooglePlacesResponse.self, from: cachedData) {
            print("✅ Loaded from cache")
            DispatchQueue.main.async {
                self.places = cachedResult.results
            }
            return
        }

        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.places = result.results

                    let cacheResult = CachedGooglePlacesResponse(results: result.results)
                    if let encoded = try? JSONEncoder().encode(cacheResult) {
                        UserDefaults.standard.set(encoded, forKey: cacheKey)
                    }
                }
            } catch {
                print("❌ JSON decode failed:", error)
            }
        }.resume()
    }

    func photoURL(from reference: String) -> URL? {
        URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=\(apiKey)")
    }

    func fetchPlaceDetails(for place: GooglePlace) {
        let cacheKey = "placeDetailsCache_\(place.name)"
        if let cachedData = UserDefaults.standard.data(forKey: cacheKey),
           let cachedResult = try? JSONDecoder().decode(GooglePlaceDetailsResponse.self, from: cachedData) {
            print("✅ Loaded from cache")
            DispatchQueue.main.async {
                let photos = (place.photos ?? []) + (cachedResult.result.photos ?? [])
                detailedPhotos = photos
                self.selectedPhoneNumber = cachedResult.result.formatted_phone_number
            }
            return
        }

        let baseQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let placeName = place.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlStr = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(placeName)&inputtype=textquery&fields=place_id&key=\(apiKey)"

        guard let findUrl = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: findUrl) { data, _, _ in
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let candidates = json["candidates"] as? [[String: Any]],
                   let placeID = candidates.first?["place_id"] as? String {

                    let detailsURL = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeID)&fields=photos,formatted_phone_number,international_phone_number&key=\(apiKey)"

                    guard let url = URL(string: detailsURL) else { return }

                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        guard let data = data else { return }
                        do {
                            let result = try JSONDecoder().decode(GooglePlaceDetailsResponse.self, from: data)
                            let photos = (place.photos ?? []) + (result.result.photos ?? [])
                            DispatchQueue.main.async {
                                detailedPhotos = photos
                                self.selectedPhoneNumber = result.result.formatted_phone_number

                                let fullDetails = GooglePlaceDetailsResponse(result: result.result)
                                if let encoded = try? JSONEncoder().encode(fullDetails) {
                                    UserDefaults.standard.set(encoded, forKey: cacheKey)
                                }
                            }
                        } catch {
                            print("❌ Failed to decode place details:", error)
                        }
                    }.resume()
                }
            } catch {
                print("❌ Failed to fetch place ID:", error)
            }
        }.resume()
    }
}

//#Preview {
//    RecommendationView(searchKeyword: "Korean")
//}
