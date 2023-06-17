//
//  iOSMapApp.swift
//  iOSMap
//
//  Created by 杉岡成哉 on 2023/06/17.
//

import SwiftUI

@main
struct iOSMapApp: App {
    var body: some Scene {
        WindowGroup {
            MapView(
                store: .init(
                    initialState: .init(),
                    reducer: MapCore()
                )
            )
        }
    }
}
