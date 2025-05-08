//
//  FavouriteView.swift
//  IOS_TASK_3
//
//  Created by Kai-Hsuan Lin on 08/05/2025
//

import SwiftUI

struct FavouriteView: View {
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
