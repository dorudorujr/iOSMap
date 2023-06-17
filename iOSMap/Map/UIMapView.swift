import SwiftUI
import MapKit
import ComposableArchitecture

struct UIMapView: UIViewRepresentable {
    private let mkMapView = MKMapView()
    private let viewStore: ViewStore<MapCore.State, MapCore.Action>
    
    init(viewStore: ViewStore<MapCore.State, MapCore.Action>) {
        self.viewStore = viewStore
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mkMapView.showsUserLocation = true
        mkMapView.userTrackingMode = .follow
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.delegate = context.coordinator
        if let centerCoordinate = viewStore.centerCoordinate {
            var region = mkMapView.region
            region.center = centerCoordinate
            region.span.latitudeDelta = 0.02
            region.span.longitudeDelta = 0.02
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        .init(parent: self, viewStore: viewStore)
    }
}

extension UIMapView {
    class Coordinator: NSObject {
        var parent: UIMapView
        // TODO: もしかしたらいらない？
        var viewStore: ViewStore<MapCore.State, MapCore.Action>
        
        init(parent: UIMapView, viewStore: ViewStore<MapCore.State, MapCore.Action>) {
            self.parent = parent
            self.viewStore = viewStore
        }
    }
}

extension UIMapView.Coordinator: MKMapViewDelegate {
    
}

extension UIMapView.Coordinator: CLLocationManagerDelegate {
}
