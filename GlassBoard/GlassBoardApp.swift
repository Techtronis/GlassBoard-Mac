//
//  GlassBoardApp.swift
//  GlassBoard
//
//  Created by Alexis Jost on 10.06.2026.
//

import SwiftUI

@main
struct GlassBoardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 600, height: 400)
        }.windowResizability(.contentSize)
    }
}
