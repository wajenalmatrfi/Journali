//
//  JournaliApp.swift
//  Journali
//
//  Created by WajenN on 29/05/1448 AH.
//

import SwiftUI
import SwiftData

/// The app's entry point.
@main
struct JournaliApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        // Creates the database that stores every Journal.
        .modelContainer(for: Journal.self)
    }
}
