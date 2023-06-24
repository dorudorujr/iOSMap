import ComposableArchitecture
import SwiftUI
import MapKit

struct MapCore: ReducerProtocol {
    struct State: Equatable {
        var menu = MenuCore.State()
        var centerCoordinate: CLLocationCoordinate2D?
        var tapAnotation: MKPointAnnotation?
    }
    
    enum Action: Equatable {
        case menu(MenuCore.Action)
        case onAppear
        case mapLongPress(coordinate: CLLocationCoordinate2D)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.menu, action: /Action.menu) {
            MenuCore()
        }
        Reduce { state, action in
            switch action {
            case .menu:
                return .none
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
}
