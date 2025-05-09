//
//  FavouriteView.swift
//  IOS_TASK_3
//
//  Created by Kai-Hsuan Lin on 08/05/2025
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var favouriteManager: FavouriteManager
    
    var body: some View {
        NavigationView {
            if favouriteManager.favourites.isEmpty {
                VStack {
                    Image(systemName: "heart")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .padding()
                    Text("No favourites yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Tap the heart icon to add restaurants to your favourites")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .navigationTitle("Favourites")
            } else {
                List {
                    ForEach(favouriteManager.favourites) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete { indices in
                        indices.forEach { index in
                            let item = favouriteManager.favourites[index]
                            favouriteManager.removeFavourite(byId: item.restaurantId)
                        }
                    }
                }
                .navigationTitle("Favourites")
                .toolbar {
                    EditButton()
                }
            }
        }
    }
}
