import ComposableArchitecture
import SwiftUI
import MapKit

struct MapCore: ReducerProtocol {
    struct State: Equatable {
        var centerCoordinate: CLLocationCoordinate2D?
        var tapAnotation: MKPointAnnotation?
    }
    
    enum Action: Equatable {
        case onAppear
        case mapLongPress(coordinate: CLLocationCoordinate2D)
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
        case let .mapLongPress(coordinate):
            let tapAnotation = MKPointAnnotation()
            tapAnotation.coordinate = coordinate
            state.tapAnotation = tapAnotation
            return .none
        }
    }
}
