//
//  ContentView.swift
//  iOSMap
//
//  Created by 杉岡成哉 on 2023/06/17.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        UIMapView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
