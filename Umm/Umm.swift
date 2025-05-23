//
//  IOS_TASK_3App.swift
//  IOS_TASK_3
//
//  Created by Josh Tsai on 2025/5/5.
//

import SwiftUI

@main
struct Umm: App {
    @StateObject private var favouriteManager = FavouriteManager()
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(favouriteManager)
        }
    }
}
