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
        
        let tapped = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.tapped)
        )
        mkMapView.addGestureRecognizer(tapped)
        let longTapped = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.longTapped)
        )
        mkMapView.addGestureRecognizer(longTapped)
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
        
        if let tapAnotation = viewStore.tapAnotation {
            uiView.addAnnotation(tapAnotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        .init(parent: self, viewStore: viewStore)
    }
}

extension UIMapView {
    class Coordinator: NSObject {
        var parent: UIMapView
        var viewStore: ViewStore<MapCore.State, MapCore.Action>
        
        init(parent: UIMapView, viewStore: ViewStore<MapCore.State, MapCore.Action>) {
            self.parent = parent
            self.viewStore = viewStore
        }
        
        @objc func tapped(gesture: UITapGestureRecognizer) {
            parent.mkMapView.removeAnnotations(parent.mkMapView.annotations)
        }
        
        @objc func longTapped(gesture: UITapGestureRecognizer) {
            let viewPoint = gesture.location(in: parent.mkMapView)
            let mapCoordinate: CLLocationCoordinate2D = parent.mkMapView.convert(viewPoint, toCoordinateFrom: parent.mkMapView)
            viewStore.send(.mapLongPress(coordinate: mapCoordinate))
            parent.mkMapView.removeAnnotations(parent.mkMapView.annotations)
        }
    }
}

extension UIMapView.Coordinator: MKMapViewDelegate {
    
}

extension UIMapView.Coordinator: CLLocationManagerDelegate {
}
