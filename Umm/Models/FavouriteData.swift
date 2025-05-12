//
//  FavouriteData.swift
//  Umm
//
//  Created by Kai-Hsuan Lin on 09/05/2025
//

import Foundation

struct FavouriteItem: Identifiable, Codable {
    let id: UUID
    let restaurantId: String
    let name: String
    let address: String
    let category: String
    let latitude: Double
    let longitude: Double
    let photoReference: String?
    
    init(restaurant: GooglePlace) {
        self.id = UUID()
        self.restaurantId = restaurant.place_id
        self.name = restaurant.name
        self.address = restaurant.formatted_address
        self.category = restaurant.types.first ?? ""
        self.latitude = restaurant.geometry.location.lat
        self.longitude = restaurant.geometry.location.lng
        self.photoReference = restaurant.photos?.first?.photo_reference
    }
}

class FavouriteManager: ObservableObject {
    @Published var favourites: [FavouriteItem] = [] {
        didSet {
            saveFavourites() // 任何修改自動儲存
        }
    }
    private let favouritesKey = "favourites"
    
    init() {
        loadFavourites()
    }
    
    func addFavourite(_ restaurant: GooglePlace) {
        let item = FavouriteItem(restaurant: restaurant)
        if !favourites.contains(where: { $0.restaurantId == item.restaurantId }) {
            favourites.append(item)
        }
    }

    func removeFavourite(byId id: String) {
        favourites.removeAll { $0.restaurantId == id }
    }
    
    func isFavourite(restaurantId: String) -> Bool {
        favourites.contains { $0.restaurantId == restaurantId }
    }
    
    private func saveFavourites() {
        do {
            let encoded = try JSONEncoder().encode(favourites)
            UserDefaults.standard.set(encoded, forKey: favouritesKey)
            print("Successfully to save favorites, current quantity: \(favourites.count)")
        } catch {
            print("Failed to save favorites: \(error.localizedDescription)")
        }
    }
    
    private func loadFavourites() {
        do {
            if let data = UserDefaults.standard.data(forKey: favouritesKey) {
                let decoded = try JSONDecoder().decode([FavouriteItem].self, from: data)
                favourites = decoded
                print("Successfully loaded favorites, current quantity: \(favourites.count)")
            }
        } catch {
            print("Failed to load favorites: \(error.localizedDescription)")
        }
    }
}
