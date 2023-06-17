import ComposableArchitecture
import SwiftUI
import MapKit

struct MapCore: ReducerProtocol {
    struct State: Equatable {
        var centerCoordinate: CLLocationCoordinate2D?
    }
    
    enum Action: Equatable {
        case onAppear
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                if let location = locationManager.location {
                    state.centerCoordinate = location.coordinate
                }
            }
            return .none
        }
    }
}
