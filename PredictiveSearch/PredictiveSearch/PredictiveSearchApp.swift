//
//  PredictiveSearchApp.swift
//  PredictiveSearch
//
//  Created by m47145 on 16/01/2026.
//

import SwiftUI

@main
struct PredictiveSearchApp: App {
    var body: some Scene {
        WindowGroup {
            MediaView(viewModel: MediaSearchViewModel(repository: MediaRepository()))
        }
    }
}
