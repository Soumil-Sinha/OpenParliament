//
//  OpenParliamentApp.swift
//  OpenParliament
//
//  Created by Soumil Sinha on 18/08/26.
//

import SwiftUI

@main
struct OpenParliamentApp: App {
    /// Owned here so every tab and pushed screen shares one copy of the data.
    @State private var store = ParliamentStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(store)
        }
    }
}
