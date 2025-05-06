//
//  FavouritesView.swift
//  IOS_TASK_3
//
//  Created by nauman mansuri on 06/05/25.
//


import SwiftUI

struct FavouritesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Favourites")
                .font(.title)
                .bold()

            Text("Your saved meals and drinks will appear here.")
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .navigationTitle("Favourites")
    }
}
